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

require 'fit4ruby/Session'
require 'fit4ruby/Lap'
require 'fit4ruby/Record'
require 'fit4ruby/FitDataRecord'

module Fit4Ruby

  class Activity < FitDataRecord

    attr_accessor :sessions, :laps, :records

    def initialize
      super('activity')
      @num_sessions = 0

      @sessions = []
      @laps = []
      @records = []
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

    def write(io, id_mapper)
      @sessions.each do |s|
        s.write(io, id_mapper)
      end
      super
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

    def ==(a)
      super(a) && @sessions == a.sessions &&
        @laps == a.laps && @records == a.records
    end

  end

end

