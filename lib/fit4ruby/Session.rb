#!/usr/bin/env ruby -w
# encoding: UTF-8
#
# = Session.rb -- Fit4Ruby - FIT file processing library for Ruby
#
# Copyright (c) 2014, 2015 by Chris Schlaeger <cs@taskjuggler.org>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of version 2 of the GNU General Public License as
# published by the Free Software Foundation.
#

require 'fit4ruby/Converters'
require 'fit4ruby/FitDataRecord'
require 'fit4ruby/RecordAggregator'
require 'fit4ruby/GeoMath'

module Fit4Ruby

  # The Session objects correspond to the session FIT messages. They hold
  # accumlated data for a set of Lap objects.
  class Session < FitDataRecord

    include RecordAggregator

    attr_reader :laps, :records

    # Create a new Session object.
    # @param laps [Array of Laps] Laps to associate with the Session.
    # @param first_lap_index [Fixnum] Index of the first Lap in this Session.
    # @param field_values [Hash] Hash that provides initial values for certain
    #        fields.
    def initialize(laps, first_lap_index, field_values)
      super('session')
      @meta_field_units['avg_stride_length'] = 'm'
      @laps = laps
      @records = []
      @laps.each { |lap| @records += lap.records }
      @first_lap_index = first_lap_index
      @num_laps = @laps.length

      if @records.first
        # Or to the timestamp of the first record.
        @start_time = @records.first.timestamp
        if @records.last
          @total_elapsed_time = @records.last.timestamp - @start_time
        end
      end

      set_field_values(field_values)
    end

    # Perform some basic consistency and logical checks on the object. Errors
    # are reported via the Log object.
    def check(activity)
      unless @first_lap_index
        Log.fatal 'first_lap_index is not set'
      end
      unless @num_laps
        Log.fatal 'num_laps is not set'
      end
      @first_lap_index.upto(@first_lap_index - @num_laps) do |i|
        if (lap = activity.lap[i])
          @laps << lap
        else
          Log.fatal "Session references lap #{i} which is not contained in "
                    "the FIT file."
        end
      end
    end

    # Return true if the session contains geographical location data.
    def has_geo_data?
      @swc_long && @swc_lat && @nec_long && nec_lat
    end

    # Compute the average stride length for this Session.
    def avg_stride_length
      return nil unless @total_strides

      @total_distance / (@total_strides * 2.0)
    end

  end

end

