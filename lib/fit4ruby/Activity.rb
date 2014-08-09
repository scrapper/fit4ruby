#!/usr/bin/env ruby -w
# encoding: UTF-8
#
# = Activity.rb -- Fit4Ruby - FIT file processing library for Ruby
#
# Copyright (c) 2014 by Chris Schlaeger <cs@taskjuggler.org>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of version 2 of the GNU General Public License as
# published by the Free Software Foundation.
#

require 'fit4ruby/FitDataRecord'
require 'fit4ruby/FileId'
require 'fit4ruby/FileCreator'
require 'fit4ruby/DeviceInfo'
require 'fit4ruby/UserProfile'
require 'fit4ruby/Session'
require 'fit4ruby/Lap'
require 'fit4ruby/Record'
require 'fit4ruby/Event'
require 'fit4ruby/PersonalRecords'

module Fit4Ruby

  class Activity < FitDataRecord

    attr_accessor :file_id, :file_creator, :device_infos, :user_profiles,
                  :sessions, :laps, :records, :events, :personal_records

    def initialize
      super('activity')
      @num_sessions = 0

      @file_id = FileId.new
      @file_creator = FileCreator.new
      @device_infos = []
      @user_profiles = []
      @events = []
      @sessions = []
      @laps = []
      @records = []
      @personal_records = []

      @cur_session_laps = []
      @cur_lap_records = []

      @lap_counter = 1
    end

    def check
      unless @timestamp && @timestamp >= Time.parse('1990-01-01')
        Log.error "Activity has no valid timestamp"
      end
      unless @total_timer_time
        Log.error "Activity has no valid total_timer_time"
      end
      unless @num_sessions == @sessions.count
        Log.error "Activity record requires #{@num_sessions}, but "
                  "#{@sessions.length} session records were found in the "
                  "FIT file."
      end
      @sessions.each { |s| s.check(self) }
    end

    def total_distance
      d = 0.0
      @sessions.each { |s| d += s.total_distance }
      d
    end

    def aggregate
      @sessions.each { |s| s.aggregate }
    end

    def avg_speed
      speed = 0.0
      @sessions.each { |s| speed += s.avg_speed }
      speed / @sessions.length
    end

    def recovery_time
      @events.each do |e|
        return e.data if e.event == 'recovery_time'
      end

      nil
    end

    def vo2max
      @events.each do |e|
        return e.data if e.event == 'vo2max'
      end

      nil
    end

    def write(io, id_mapper)
      @file_id.write(io, id_mapper)
      @file_creator.write(io, id_mapper)

      (@device_infos + @user_profiles + @events + @sessions + @laps +
       @records + @personal_records).sort.each do |s|
        s.write(io, id_mapper)
      end
      super
    end

    def new_file_id(field_values = {})
      new_fit_data_record('file_id', field_values)
    end

    def new_file_creator(field_values = {})
      new_fit_data_record('file_creator', field_values)
    end

    def new_device_info(field_values = {})
      new_fit_data_record('device_info', field_values)
    end

    def new_user_profile(field_values = {})
      new_fit_data_record('user_profile', field_values)
    end

    def new_event(field_values = {})
      new_fit_data_record('event', field_values)
    end

    def new_session(field_values = {})
      new_fit_data_record('session', field_values)
    end

    def new_lap(field_values = {})
      new_fit_data_record('lap', field_values)
    end

    def new_personal_record(field_values = {})
      new_fit_data_record('personal_record', field_values)
    end

    def new_record(field_values = {})
      new_fit_data_record('record', field_values)
    end

    def ==(a)
      super(a) && @file_id == a.file_id &&
        @file_creator == a.file_creator &&
        @device_infos == a.device_infos && @user_profiles == a.user_profiles &&
        @events == a.events &&
        @sessions == a.sessions && personal_records == a.personal_records
    end

    def new_fit_data_record(record_type, field_values = {})
      case record_type
      when 'file_id'
        @file_id = (record = FileId.new(field_values))
      when 'file_creator'
        @file_creator = (record = FileCreator.new(field_values))
      when 'device_info'
        @device_infos << (record = DeviceInfo.new(field_values))
      when 'user_profile'
        @user_profiles << (record = UserProfile.new(field_values))
      when 'event'
        @events << (record = Event.new(field_values))
      when 'session'
        unless @cur_lap_records.empty?
          # Ensure that all previous records have been assigned to a lap.
          @lap_counter += 1
          @cur_session_laps << (lap = Lap.new(@cur_lap_records, field_values))
          @laps << lap
          @cur_lap_records = []
        end
        @num_sessions += 1
        @sessions << (record = Session.new(@cur_session_laps, @lap_counter,
                                           field_values))
        @cur_session_laps = []
      when 'lap'
        @lap_counter += 1
        @cur_session_laps << (record = Lap.new(@cur_lap_records, field_values))
        @laps << record
        @cur_lap_records = []
      when 'record'
        @cur_lap_records << (record = Record.new(field_values))
        @records << record
      when 'personal_records'
        @personal_records << (record = PersonalRecords.new(field_values))
      else
        record = nil
      end

      record
    end

  end

end

