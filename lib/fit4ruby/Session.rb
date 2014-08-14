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

  # The Session objects correspond to the session FIT messages. They hold
  # accumlated data for a set of Lap objects.
  class Session < FitDataRecord

    include Converters

    attr_reader :laps

    # Create a new Session object.
    # @param laps [Array of Laps] Laps to associate with the Session.
    # @param first_lap_index [Fixnum] Index of the first Lap in this Session.
    # @param field_values [Hash] Hash that provides initial values for certain
    #        fields.
    def initialize(laps, first_lap_index, field_values)
      super('session')
      @laps = laps
      @first_lap_index = first_lap_index
      @num_laps = @laps.length
      set_field_values(field_values)
    end

    # Perform some basic consistency and logical checks on the object. Errors
    # are reported via the Log object.
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

    # Aggregate the data from the Laps associated with this session and store
    # them in the fields. Calling this method will override any previously
    # stored values.
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

    # Return true if the session contains geographical location data.
    def has_geo_data?
      @swc_long && @swc_lat && @nec_long && nec_lat
    end

    # Compute the average stride length for this Session.
    def avg_stride_length
      return nil unless @total_strides

      @total_distance / @total_strides
    end

  end

end

