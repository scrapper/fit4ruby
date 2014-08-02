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

require 'fit4ruby/FileCreator'
require 'fit4ruby/DeviceInfo'
require 'fit4ruby/Session'
require 'fit4ruby/Lap'
require 'fit4ruby/Record'
require 'fit4ruby/Event'
require 'fit4ruby/UserProfile'
require 'fit4ruby/FitDataRecord'
require 'fit4ruby/PersonalRecords'

module Fit4Ruby

  class Activity < FitDataRecord

    attr_accessor :file_creators, :device_info, :user_profiles,
                  :sessions, :laps, :records, :events, :personal_records

    def initialize
      super('activity')
      @num_sessions = 0

      @file_creators = []
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
        Log.error "Activity has no valid start time"
      end
      unless @total_timer_time
        Log.error "Activity has no valid duration"
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
      (@file_creators + @device_infos + @user_profiles +
       @sessions + @events + @personal_records).each do |s|
        s.write(io, id_mapper)
      end
      super
    end

    def new_file_creator
      @file_creators << (file_creator = FileCreator.new)
      file_creator
    end

    def new_device_info
      @device_infos << (device_info = DeviceInfo.new)
      device_info
    end

    def new_session
      @num_sessions += 1
      @sessions << (session = Session.new(@laps, @lap_counter))
      @laps = []
      session
    end

    def new_lap
      @lap_counter += 1
      @laps << (lap = Lap.new(@records))
      @records = []
      lap
    end

    def new_record
      @records << (record = Record.new)
      record
    end

    def new_event
      @events << (event = Event.new)
      event
    end

    def new_user_profile
      @user_profiles << (user_profile = UserProfile.new)
      user_profile
    end

    def new_personal_records
      @personal_records << (personal_record = PersonalRecords.new)
      personal_record
    end

    def ==(a)
      super(a) && @sessions == a.sessions &&
        @events == a.events
    end

  end

end

