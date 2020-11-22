#!/usr/bin/env ruby -w
# encoding: UTF-8
#
# = Activity.rb -- Fit4Ruby - FIT file processing library for Ruby
#
# Copyright (c) 2014, 2015, 2020 by Chris Schlaeger <cs@taskjuggler.org>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of version 2 of the GNU General Public License as
# published by the Free Software Foundation.
#

require 'fit4ruby/FitDataRecord'
require 'fit4ruby/FileId'
require 'fit4ruby/FieldDescription'
require 'fit4ruby/DeveloperDataId'
require 'fit4ruby/EPO_Data'
require 'fit4ruby/FileCreator'
require 'fit4ruby/DeviceInfo'
require 'fit4ruby/SensorSettings'
require 'fit4ruby/DataSources'
require 'fit4ruby/UserData'
require 'fit4ruby/UserProfile'
require 'fit4ruby/PhysiologicalMetrics'
require 'fit4ruby/Session'
require 'fit4ruby/Lap'
require 'fit4ruby/Length'
require 'fit4ruby/Record'
require 'fit4ruby/HRV'
require 'fit4ruby/HeartRateZones'
require 'fit4ruby/Event'
require 'fit4ruby/PersonalRecords'

module Fit4Ruby

  # Activity files are arguably the most common type of FIT file. The Activity
  # class represents the top-level structure of an activity FIT file.
  # It holds references to all other data structures. Each of the objects it
  # references are direct equivalents of the message record structures used in
  # the FIT file.
  class Activity < FitDataRecord

    attr_accessor :file_id, :field_descriptions, :developer_data_ids, :epo_data,
                  :file_creator, :device_infos, :sensor_settings, :data_sources,
                  :user_data, :user_profiles, :physiological_metrics,
                  :sessions, :laps, :records, :lengths, :hrv,
                  :heart_rate_zones, :events, :personal_records

    # Create a new Activity object.
    # @param field_values [Hash] A Hash that provides initial values for
    #        certain fields of the FitDataRecord.
    def initialize(field_values = {})
      super('activity')

      # The variables hold references to other parts of the FIT file. These
      # can either be direct references to a certain FIT file section or an
      # Array in case the section can appear multiple times in the FIT file.
      @file_id = FileId.new
      @file_creator = FileCreator.new
      @epo_data = nil
      @field_descriptions = []
      @developer_data_ids = []
      @device_infos = []
      @sensor_settings = []
      @data_sources = []
      @user_data = []
      @user_profiles = []
      @physiological_metrics = []
      @events = []
      @sessions = []
      @laps = []
      @lengths = []
      @records = []
      @hrv = []
      @heart_rate_zones = []
      @personal_records = []

      # The following variables hold derived or auxilliary information that
      # are not directly part of the FIT file.
      @meta_field_units['total_gps_distance'] = 'm'
      @cur_session_laps = []

      @cur_lap_records = []
      @cur_lap_lengths = []

      @cur_length_records = []

      @lap_counter = 1
      @length_counter = 1

      set_field_values(field_values)
    end

    # Perform some basic logical checks on the object and all references sub
    # objects. Any errors will be reported via the Log object.
    def check
      unless @timestamp && @timestamp >= Time.parse('1990-01-01T00:00:00+00:00')
        Log.fatal "Activity has no valid timestamp"
      end
      unless @total_timer_time
        Log.fatal "Activity has no valid total_timer_time"
      end
      unless @device_infos.length > 0
        Log.fatal "Activity must have at least one device_info section"
      end
      @device_infos.each.with_index { |d, index| d.check(index) }
      @sensor_settings.each.with_index { |s, index| s.check(index) }

      # Records must have consecutively growing timestamps and distances.
      ts = Time.parse('1989-12-31')
      distance = nil
      invalid_records = []
      @records.each_with_index do |r, idx|
        Log.fatal "Record has no timestamp" unless r.timestamp
        if r.timestamp < ts
          Log.fatal "Record has earlier timestamp than previous record"
        end
        if r.distance
          if distance && r.distance < distance
            # Normally this should be a fatal error as the FIT file is clearly
            # broken. Unfortunately, the Skiing/Boarding app in the Fenix3
            # produces such broken FIT files. So we just warn about this
            # problem and discard the earlier records.
            Log.error "Record #{r.timestamp} has smaller distance " +
                      "(#{r.distance}) than an earlier record (#{distance})."
            # Index of the list record to be discarded.
            (idx - 1).downto(0) do |i|
              if (ri = @records[i]).distance > r.distance
                # This is just an approximation. It looks like the app adds
                # records to the FIT file for runs that it meant to discard.
                # Maybe the two successive time start events are a better
                # criteria. But this workaround works for now.
                invalid_records << ri
              else
                # All broken records have been found.
                break
              end
            end
          end
          distance = r.distance
        end
        ts = r.timestamp
      end
      unless invalid_records.empty?
        # Delete all the broken records from the @records Array.
        Log.warn "Discarding #{invalid_records.length} earlier records"
        @records.delete_if { |r| invalid_records.include?(r) }
      end

      # Laps must have a consecutively growing message index.
      @laps.each.with_index do |lap, index|
        lap.check(index, self)
        # If we have heart rate zone records, there should be one for each
        # lap
        @heart_rate_zones[index].check(index) if @heart_rate_zones[index]
      end

      # Lengths must have a consecutively growing message index.
      @lengths.each.with_index do |length, index|
        length.check(index)
        # If we have heart rate zone records, there should be one for each
        # length
        @heart_rate_zones[index].check(index) if @heart_rate_zones[index]
      end

      @sessions.each { |s| s.check(self) }
    end

    # Convenience method that aggregates all the distances from the included
    # sessions.
    def total_distance
      d = 0.0
      @sessions.each { |s| d += s.total_distance }
      d
    end

    # Total distance convered by this activity purely computed by the GPS
    # coordinates. This may differ from the distance computed by the device as
    # it can be based on a purely calibrated footpod.
    def total_gps_distance
      timer_stops = []
      # Generate a list of all timestamps where the timer was stopped.
      @events.each do |e|
        if e.event == 'timer' && e.event_type == 'stop_all'
          timer_stops << e.timestamp
        end
      end

      # The first record of a FIT file can already have a distance associated
      # with it. The GPS location of the first record is not where the start
      # button was pressed. This introduces a slight inaccurcy when computing
      # the total distance purely on the GPS coordinates found in the records.
      d = 0.0
      last_lat = last_long = nil
      last_timestamp = nil

      # Iterate over all the records and accumlate the distances between the
      # neiboring coordinates.
      @records.each do |r|
        if (lat = r.position_lat) && (long = r.position_long)
          if last_lat && last_long
            distance = Fit4Ruby::GeoMath.distance(last_lat, last_long,
                                                  lat, long)
            d += distance
          end
          if last_timestamp
            speed = distance / (r.timestamp - last_timestamp)
          end
          if timer_stops[0] == r.timestamp
            # If a stop event was found for this record timestamp we clear the
            # last_* values so that the distance covered while being stopped
            # is not added to the total.
            last_lat = last_long = nil
            last_timestamp = nil
            timer_stops.shift
          else
            last_lat = lat
            last_long = long
            last_timestamp = r.timestamp
          end
        end
      end
      d
    end

    # Call this method to update the aggregated data fields stored in Lap,
    # Length, and Session objects.
    def aggregate
      @laps.each { |l| l.aggregate }
      @lengths.each { |l| l.aggregate }
      @sessions.each { |s| s.aggregate }
    end

    # Convenience method that averages the speed over all sessions.
    def avg_speed
      speed = 0.0
      @sessions.each do |s|
        if (spd = s.avg_speed || s.enhanced_avg_speed)
          speed += spd
        end
      end
      speed / @sessions.length
    end

    # Return the heart rate when the activity recording was last stopped.
    def ending_hr
      @records.empty? ? nil : @records[-1].heart_rate
    end

    # Return the measured recovery heart rate.
    def recovery_hr
      @events.each do |e|
        return e.recovery_hr if e.event == 'recovery_hr'
      end

      nil
    end

    # Returns the remaining recovery time at the start of the activity.
    # @return remaining recovery time in seconds.
    def recovery_info
      @events.each do |e|
        return e.recovery_info if e.event == 'recovery_info'
      end

      nil
    end

    # Returns the predicted recovery time needed after this activity.
    # @return recovery time in seconds.
    def recovery_time
      @events.each do |e|
        return e.recovery_time if e.event == 'recovery_time'
      end

      nil
    end

    # Returns the computed VO2max value. This value is computed by the device
    # based on multiple previous activities.
    def vo2max
      # First check the event log for a vo2max reporting event.
      @events.each do |e|
        return e.vo2max if e.event == 'vo2max'
      end
      # Then check the user_data entries for a metmax entry. METmax * 3.5
      # is same value as VO2max.
      @user_data.each do |u|
        return u.metmax * 3.5 if u.metmax
      end

      nil
    end

    # Returns the sport type of this activity.
    def sport
      @sessions[0].sport
    end

    # Returns the sport subtype of this activity.
    def sub_sport
      @sessions[0].sub_sport
    end

    # Write the Activity data to a file.
    # @param io [IO] File reference
    # @param id_mapper [FitMessageIdMapper] Maps global FIT record types to
    #        local ones.
    def write(io, id_mapper)
      @file_id.write(io, id_mapper)
      @file_creator.write(io, id_mapper)
      @epo_data.write(io, id_mapper) if @epo_data

      (@field_descriptions + @developer_data_ids +
       @device_infos + @sensor_settings +
       @data_sources + @user_data + @user_profiles +
       @physiological_metrics + @events +
       @sessions + @laps + @records + @lengths +
       @heart_rate_zones + @personal_records).sort.each do |s|
        s.write(io, id_mapper)
      end
      super
    end

    # Add a new FileId to the Activity. It will replace any previously added
    # FileId object.
    # @param field_values [Hash] A Hash that provides initial values for
    #        certain fields of the FitDataRecord.
    # @return [FileId]
    def new_file_id(field_values = {})
      new_fit_data_record('file_id', field_values)
    end

    # Add a new FieldDescription to the Activity.
    # @param field_values [Hash] A Hash that provides initial values for
    #        certain fields of the FitDataRecord.
    # @return [FieldDescription]
    def new_field_description(field_values = {})
      new_fit_data_record('field_description', field_values)
    end

    # Add a new DeveloperDataId to the Activity.
    # @param field_values [Hash] A Hash that provides initial values for
    #        certain fields of the FitDataRecord.
    # @return [DeveloperDataId]
    def new_developer_data_id(field_values = {})
      new_fit_data_record('developer_data_id', field_values)
    end

    # Add a new FileCreator to the Activity. It will replace any previously
    # added FileCreator object.
    # @param field_values [Hash] A Hash that provides initial values for
    #        certain fields of the FitDataRecord.
    # @return [FileCreator]
    def new_file_creator(field_values = {})
      new_fit_data_record('file_creator', field_values)
    end

    # Add a new DeviceInfo to the Activity.
    # @param field_values [Hash] A Hash that provides initial values for
    #        certain fields of the FitDataRecord.
    # @return [DeviceInfo]
    def new_device_info(field_values = {})
      new_fit_data_record('device_info', field_values)
    end

    # Add a new SourceData to the Activity.
    # @param field_values [Hash] A Hash that provides initial values for
    #        certain fields of the FitDataRecord.
    # @return [SourceData]
    def new_data_sources(field_values = {})
      new_fit_data_record('data_sources', field_values)
    end

    # Add a new UserData to the Activity.
    # @param field_values [Hash] A Hash that provides initial values for
    #        certain fields of the FitDataRecord.
    # @return [UserData]
    def new_user_data(field_values = {})
      new_fit_data_record('user_data', field_values)
    end

    # Add a new UserProfile to the Activity.
    # @param field_values [Hash] A Hash that provides initial values for
    #        certain fields of the FitDataRecord.
    # @return [UserProfile]
    def new_user_profile(field_values = {})
      new_fit_data_record('user_profile', field_values)
    end

    # Add a new PhysiologicalMetrics to the Activity.
    # @param field_values [Hash] A Hash that provides initial values for
    #        certain fields of the FitDataRecord.
    # @return [PhysiologicalMetrics]
    def new_physiological_metrics(field_values = {})
      new_fit_data_record('physiological_metrics', field_values)
    end

    # Add a new Event to the Activity.
    # @param field_values [Hash] A Hash that provides initial values for
    #        certain fields of the FitDataRecord.
    # @return [Event]
    def new_event(field_values = {})
      new_fit_data_record('event', field_values)
    end

    # Add a new Session to the Activity. All previously added Lap objects are
    # associated with this Session unless they have been associated with
    # another Session before. If there are any Record objects that have not
    # yet been associated with a Lap, a new lap will be created and the
    # Record objects will be associated with this Lap. The Lap will be
    # associated with the newly created Session.
    # @param field_values [Hash] A Hash that provides initial values for
    #        certain fields of the FitDataRecord.
    # @return [Session]
    def new_session(field_values = {})
      new_fit_data_record('session', field_values)
    end

    # Add a new Lap to the Activity. All previoulsy added Record objects are
    # associated with this Lap unless they have been associated with another
    # Lap before.
    # @param field_values [Hash] A Hash that provides initial values for
    #        certain fields of the FitDataRecord.
    # @return [Lap]
    def new_lap(field_values = {})
      new_fit_data_record('lap', field_values)
    end

    # Add a new Length to the Activity. All previoulsy added Record objects are
    # associated with this Length unless they have been associated with another
    # Length before.
    # @param field_values [Hash] A Hash that provides initial values for
    #        certain fields of the FitDataRecord.
    # @return [Length]
    def new_length(field_values = {})
      new_fit_data_record('length', field_values)
    end

    # Add a new HeartRateZones record to the Activity.
    # @param field_values [Heash] A Hash that provides initial values for
    #        certain fields of the FitDataRecord.
    # @return [HeartRateZones]
    def new_heart_rate_zones(field_values = {})
      new_fit_data_record('heart_rate_zones', field_values)
    end

    # Add a new PersonalRecord to the Activity.
    # @param field_values [Hash] A Hash that provides initial values for
    #        certain fields of the FitDataRecord.
    # @return [PersonalRecord]
    def new_personal_record(field_values = {})
      new_fit_data_record('personal_record', field_values)
    end

    # Add a new Record to the Activity.
    # @param field_values [Hash] A Hash that provides initial values for
    #        certain fields of the FitDataRecord.
    # @return [Record]
    def new_record(field_values = {})
      new_fit_data_record('record', field_values)
    end

    # Check if the current Activity is equal to the passed Activity.
    # @param a [Activity] Activity to compare this Activity with.
    # @return [TrueClass/FalseClass] true if both Activities are equal,
    # otherwise false.
    def ==(a)
      super(a) &&
        @file_id == a.file_id &&
        @field_descriptions == a.field_descriptions &&
        @developer_data_ids == a.developer_data_ids &&
        @epo_data == a.epo_data &&
        @file_creator == a.file_creator &&
        @device_infos == a.device_infos &&
        @sensor_settings == a.sensor_settings &&
        @data_sources == a.data_sources &&
        @user_data == a.user_data &&
        @user_profiles == a.user_profiles &&
        @physiological_metrics == a.physiological_metrics &&
        @events == a.events &&
        @sessions == a.sessions &&
        @laps == a.laps &&
        @lengths == a.lengths &&
        @records == a.records &&
        @hrv == a.hrv &&
        @heart_rate_zones == a.heart_rate_zones &&
        @personal_records == a.personal_records
    end

    # Create a new FitDataRecord.
    # @param record_type [String] Type that identifies the FitDataRecord
    #        derived class to create.
    # @param field_values [Hash] A Hash that provides initial values for
    #        certain fields of the FitDataRecord.
    # @return FitDataRecord
    def new_fit_data_record(record_type, field_values = {})
      case record_type
      when 'file_id'
        @file_id = (record = FileId.new(field_values))
      when 'field_description'
        @field_descriptions << (record = FieldDescription.new(field_values))
      when 'developer_data_id'
        @developer_data_ids << (record = DeveloperDataId.new(field_values))
      when 'epo_data'
        @epo_data = (record = EPO_Data.new(field_values))
      when 'file_creator'
        @file_creator = (record = FileCreator.new(field_values))
      when 'device_info'
        @device_infos << (record = DeviceInfo.new(field_values))
      when 'sensor_settings'
        @sensor_settings << (record = SensorSettings.new(field_values))
      when 'data_sources'
        @data_sources << (record = DataSources.new(field_values))
      when 'user_data'
        @user_data << (record = UserData.new(field_values))
      when 'user_profile'
        @user_profiles << (record = UserProfile.new(field_values))
      when 'physiological_metrics'
        @physiological_metrics <<
          (record = PhysiologicalMetrics.new(field_values))
      when 'event'
        @events << (record = Event.new(field_values))
      when 'session'
        unless @cur_lap_records.empty?
          # Copy selected fields from section to lap.
          lap_field_values = {}
          [ :timestamp, :sport ].each do |f|
            lap_field_values[f] = field_values[f] if field_values.include?(f)
          end
          # Ensure that all previous records have been assigned to a lap.
          record = create_new_lap(lap_field_values)
        end
        @sessions << (record = Session.new(@cur_session_laps, @lap_counter,
                                           field_values))
        @cur_session_laps = []
      when 'lap'
        record = create_new_lap(field_values)
      when 'length'
        record = create_new_length(field_values)
      when 'record'
        record = Record.new(field_values)
        @cur_lap_records << record
        @cur_length_records << record
        @records << record
      when 'hrv'
        @hrv << (record = HRV.new(field_values))
      when 'heart_rate_zones'
        @heart_rate_zones << (record = HeartRateZones.new(field_values))
      when 'personal_records'
        @personal_records << (record = PersonalRecords.new(field_values))
      else
        record = nil
      end

      record
    end

    def export
      {
        file_id: @file_id.export,
        file_creator: @file_creator.export,
        epo_data: @epo_data ? @epo_data.export : nil,

        field_descriptions: export_list(@field_descriptions),
        developer_data_ids: export_list(@developer_data_ids),
        device_infos: export_list(@device_infos),
        sensor_settings: export_list(@sensor_settings),
        data_sources: export_list(@data_sources),
        user_data: export_list(@user_data),
        user_profiles: export_list(@user_profiles),
        physiological_metrics: export_list(@physiological_metrics),
        events: export_list(@events),
        sessions: export_list(@sessions),
        laps: export_list(@laps),
        lengths: export_list(@lengths),
        records: export_list(@records),
        hrv: export_list(@hrv),
        heart_rate_zones: export_list(@heart_rate_zones),
        personal_records: export_list(@personal_records)
      }
    end

    private

    def create_new_lap(field_values)
      lap = Lap.new(@cur_lap_records, @laps.last,
                    field_values,
                    @length_counter, @cur_lap_lengths)
      lap.message_index = @lap_counter - 1
      @lap_counter += 1
      @cur_session_laps << lap
      @laps << lap
      @cur_lap_records = []
      @cur_lap_lengths = []

      lap
    end

    def create_new_length(field_values)
      length = Length.new(@cur_length_records, @lengths.last, field_values)
      length.message_index = @length_counter - 1
      @length_counter += 1
      @cur_lap_lengths << length
      @lengths << length
      @cur_length_records = []

      length
    end

    def export_list(list)
      list.sort.map { |e| e.export }
    end

  end

end

