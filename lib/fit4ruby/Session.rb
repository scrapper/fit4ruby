#!/usr/bin/env ruby -w
# encoding: UTF-8
#
# = Session.rb -- Fit4Ruby - FIT file processing library for Ruby
#
# Copyright (c) 2014 by Chris Schlaeger <cs@taskjuggler.org>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of version 2 of the GNU General Public License as
# published by the Free Software Foundation.
#

require 'fit4ruby/Converters'
require 'fit4ruby/FitDataRecord'

module Fit4Ruby

  class Session < FitDataRecord

    include Converters

    attr_reader :laps

    def initialize(laps, first_lap_index)
      super('session')
      @laps = laps
      puts laps.length
      @first_lap_index = first_lap_index
      @num_laps = @laps.length
    end

    def check(activity)
      unless @first_lap_index
        Log.error 'first_lap_index is not set'
      end
      unless @num_laps
        Log.error 'num_laps is not set'
      end
      @first_lap_index.upto(@first_lap_index - @num_laps) do |i|
        if (lap = activity.lap[i])
          @laps << lap
        else
          Log.error "Session references lap #{i} which is not contained in "
                    "the FIT file."
        end
      end
      @laps.each { |l| l.check }
    end

    def aggregate
      @total_distance = 0
      @total_elapsed_time = 0
      @laps.each do |lap|
        lap.aggregate
        @total_distance += lap.total_distance if lap.total_distance
        @total_elapsed_time += lap.total_elapsed_time if lap.total_elapsed_time
      end
      if (l = @laps[0])
        @start_time = l.start_time
        @start_position_lat = l.start_position_lat
        @start_position_long = l.start_position_long
      end
      if (l = @laps[-1])
        @end_position_lat = l.end_position_lat
        @end_position_long = l.end_position_long
      end

      if @total_distance && @total_elapsed_time
        @avg_speed = @total_distance / @total_elapsed_time
      end
    end

    def write(io, id_mapper)
      @laps.each do |s|
        s.write(io, id_mapper)
      end
      super
    end

    def avg_stride_length
      return nil unless @total_strides

      @total_distance / @total_strides
    end

  end

end

