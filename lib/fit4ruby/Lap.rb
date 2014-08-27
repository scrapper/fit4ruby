#!/usr/bin/env ruby -w
# encoding: UTF-8
#
# = Lap.rb -- Fit4Ruby - FIT file processing library for Ruby
#
# Copyright (c) 2014 by Chris Schlaeger <cs@taskjuggler.org>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of version 2 of the GNU General Public License as
# published by the Free Software Foundation.
#

require 'fit4ruby/FitDataRecord'

module Fit4Ruby

  class Lap < FitDataRecord

    attr_reader :records

    def initialize(records, previous_lap, field_values)
      super('lap')
      @meta_field_units['avg_stride_length'] = 'm'
      @records = records
      @previous_lap = previous_lap

      if previous_lap && previous_lap.records && previous_lap.records.last
        # Set the start time of the new lap to the timestamp of the last record
        # of the previous lap.
        @start_time = previous_lap.records.last.timestamp
      elsif records.first
        # Or to the timestamp of the first record.
        @start_time = records.first.timestamp
      end

      if records.last
        @total_elapsed_time = records.last.timestamp - @start_time
      end

      set_field_values(field_values)
    end

    def check
      ts = Time.parse('1989-12-31')
      distance = nil
      @records.each do |r|
        Log.error "Record has no timestamp" unless r.timestamp
        if r.timestamp < ts
          Log.error "Record has earlier timestamp than previous record"
        end
        if r.distance
          if distance && r.distance < distance
            Log.error "Record has smaller distance than previous record"
          end
          distance = r.distance
        end
        ts = r.timestamp
      end
    end

    def aggregate
      return if @records.empty?

      r = @records[0]
      @start_position_lat = r.position_lat
      @start_position_long = r.position_long

      r = @records[-1]
      @end_position_lat = r.position_lat
      @end_position_long = r.position_long

      # TODO: Add support for pause events.
      @total_timer_time = @total_elapsed_time

      @max_speed = 0
      @total_ascent = @total_descent = 0
      @total_strides = 0
      @max_running_cadence = 0
      total_heart_beats = 0
      @max_heart_rate = 0
      first_distance, last_distance = nil, nil
      if @previous_lap && @previous_lap.records && @previous_lap.records.last
        last_timestamp = @previous_lap.records.last.timestamp
      else
        last_timestamp = nil
      end
      height = nil
      @records.each do |r|
        first_distance = r.distance if first_distance.nil? && r.distance
        last_distance = r.distance if r.distance
        @max_speed = r.speed if r.speed && @max_speed < r.speed

        if r.position_lat
          if (@swc_lat.nil? || r.position_lat < @swc_lat)
            @swc_lat = r.position_lat
          end
          if (@nec_lat.nil? || r.position_lat > @nec_lat)
            @nec_lat = r.position_lat
          end
        end
        if r.position_long
          if (@swc_long.nil? || r.position_long < @swc_long)
            @swc_long = r.position_long
          end
          if (@nec_long.nil? || r.position_long > @nec_long)
            @nec_long = r.position_long
          end
        end

        if height
          if r.altitude < height
            @total_descent += (height - r.altitude)
          else
            @total_ascent += (r.altitude - height)
          end
          height = r.altitude
        end

        delta_t = last_timestamp ? r.timestamp - last_timestamp : nil
        if delta_t && (run_cadence = r.run_cadence)
          @total_strides += (run_cadence / 60.0) * delta_t
        end
        if run_cadence && run_cadence > @max_running_cadence
          @max_running_cadence = run_cadence.to_i
        end
        if r.heart_rate
          total_heart_beats += (r.heart_rate / 60.0) * delta_t if delta_t
          if r.heart_rate > @max_heart_rate
            @max_heart_rate = r.heart_rate
          end
        end

        last_timestamp = r.timestamp
      end

      @avg_running_cadence, @avg_fractional_cadence =
        (@total_strides.to_f / @total_timer_time * (60 / 2)).divmod(1)
      @total_strides = @total_strides.to_i
      @total_distance = last_distance && first_distance ?
        last_distance - first_distance : 0
      @avg_speed = @total_distance.to_f / @total_elapsed_time
      @avg_heart_rate = (total_heart_beats.to_f / @total_elapsed_time * 60).to_i
    end

    # Compute the average stride length for this Session.
    def avg_stride_length
      return nil unless @total_strides

      @total_distance / (@total_strides * 2.0)
    end

  end

end

