#!/usr/bin/env ruby -w
# encoding: UTF-8
#
# = RecordAggregator.rb -- Fit4Ruby - FIT file processing library for Ruby
#
# Copyright (c) 2014 by Chris Schlaeger <cs@taskjuggler.org>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of version 2 of the GNU General Public License as
# published by the Free Software Foundation.
#

module Fit4Ruby

  module RecordAggregator

    def aggregate
      return if @records.empty?

      # TODO: Add support for pause events.
      @total_timer_time = @total_elapsed_time

      aggregate_geo_region
      aggregate_ascent_descent
      aggregate_speed_distance
      aggregate_heart_rate
      aggregate_strides
      aggregate_vertical_oscillation
      aggregate_stance_time
    end

    def aggregate_geo_region
      r = @records.first
      @start_position_lat = r.position_lat
      @start_position_long = r.position_long

      r = @records.last
      @end_position_lat = r.position_lat
      @end_position_long = r.position_long

      @records.each do |r|
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
      end
    end

    def aggregate_ascent_descent
      @total_ascent = @total_descent = 0
      altitude = nil

      @records.each do |r|
        if altitude
          if r.altitude < altitude
            @total_descent += (altitude - r.altitude)
          else
            @total_ascent += (r.altitude - altitude)
          end
        end
        altitude = r.altitude
      end
    end

    def aggregate_speed_distance
      @max_speed = 0
      first_distance, last_distance = nil, nil

      @records.each do |r|
        @max_speed = r.speed if r.speed && @max_speed < r.speed

        first_distance = r.distance if first_distance.nil? && r.distance
        last_distance = r.distance if r.distance
      end

      @total_distance = last_distance && first_distance ?
        last_distance - first_distance : 0
      @avg_speed = @total_distance.to_f / @total_elapsed_time
    end

    def aggregate_heart_rate
      total_heart_beats = 0
      @max_heart_rate = 0
      last_timestamp = @start_time

      @records.each do |r|
        if r.heart_rate
          delta_t = last_timestamp ? r.timestamp - last_timestamp : nil
          total_heart_beats += (r.heart_rate / 60.0) * delta_t if delta_t
          if r.heart_rate > @max_heart_rate
            @max_heart_rate = r.heart_rate
          end
        end
        last_timestamp = r.timestamp
      end
      @avg_heart_rate = (total_heart_beats.to_f / @total_elapsed_time * 60).to_i
    end

    def aggregate_strides
      @total_strides = 0
      @max_running_cadence = 0
      last_timestamp = @start_time

      @records.each do |r|
        delta_t = last_timestamp ? r.timestamp - last_timestamp : nil

        if delta_t && (run_cadence = r.run_cadence)
          @total_strides += (run_cadence / 60.0) * delta_t
        end
        if run_cadence && run_cadence > @max_running_cadence
          @max_running_cadence = run_cadence.to_i
        end

        last_timestamp = r.timestamp
      end
      @avg_running_cadence, @avg_fractional_cadence =
        (@total_strides.to_f / @total_timer_time * (60 / 2)).divmod(1)
      @total_strides = @total_strides.to_i
    end

    def aggregate_vertical_oscillation
      total_vertical_oscillation = 0.0
      vertical_oscillation_count = 0

      @records.each do |r|
        if r.vertical_oscillation
          total_vertical_oscillation += r.vertical_oscillation
          vertical_oscillation_count += 1
        end
      end

      @avg_vertical_oscillation = total_vertical_oscillation /
        vertical_oscillation_count
    end

    def aggregate_stance_time
      total_stance_time = 0.0
      total_stance_time_percent = 0.0
      stance_time_count = 0
      stance_time_percent_count = 0

      @records.each do |r|
        if r.stance_time
          total_stance_time += r.stance_time
          stance_time_count += 1
        end
        if r.stance_time_percent
          total_stance_time_percent += r.stance_time_percent
          stance_time_percent_count += 1
        end
      end

      @avg_stance_time = stance_time_count > 0 ?
        total_stance_time / stance_time_count : 0
      @avg_stance_time_percent = stance_time_percent_count > 0 ?
        total_stance_time_percent / stance_time_percent_count : 0
    end

  end

end

