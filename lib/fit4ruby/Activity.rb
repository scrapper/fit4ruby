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
      @sessions = []
      @laps = []
      @records = []
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

    def new_session
      @sessions << (session = Session.new)
      session
    end

    def new_lap
      @laps << (lap = Lap.new)
      lap
    end

    def new_record
      @records << (record = Record.new)
      record
    end

  end

end

