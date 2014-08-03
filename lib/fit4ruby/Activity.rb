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
      @sessions = []
      @laps = []
      @records = []
      @events = []
      @personal_records = []

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

    def write(io, id_mapper)
      @file_id.write(io, id_mapper)
      @file_creator.write(io, id_mapper)

      (@device_infos + @user_profiles + @events +
       @sessions + @personal_records).each do |s|
        s.write(io, id_mapper)
      end
      super
    end

    def new_record(record_type)
      case record_type
      when 'file_id'
        @file_id = (record = FileId.new)
      when 'file_creator'
        @file_creator = (record = FileCreator.new)
      when 'device_info'
        @device_infos << (record = DeviceInfo.new)
      when 'user_profile'
        @user_profiles << (record = UserProfile.new)
      when 'event'
        @events << (record = Event.new)
      when 'session'
        unless @records.empty?
          # Ensure that all previous records have been assigned to a lap.
          @lap_counter += 1
          @laps << Lap.new(@records)
          @records = []
        end
        @num_sessions += 1
        @sessions << (record = Session.new(@laps, @lap_counter))
        @laps = []
      when 'lap'
        @lap_counter += 1
        @laps << (record = Lap.new(@records))
        @records = []
      when 'personal_records'
        @personal_records << (record = PersonalRecords.new)
      when 'record'
        @records << (record = Record.new)
      else
        record = nil
      end

      record
    end

    def ==(a)
      super(a) && @file_id == a.file_id &&
        @file_creator == a.file_creator &&
        @device_infos == a.device_infos && @user_profiles == a.user_profiles &&
        @events == a.events &&
        @sessions == a.sessions && personal_records == a.personal_records
    end

  end

end

