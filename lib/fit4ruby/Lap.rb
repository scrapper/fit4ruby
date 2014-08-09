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

    def initialize(records, field_values)
      super('lap')
      @records = records
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
      @start_time = r.timestamp
      @start_position_lat = r.position_lat
      @start_position_long = r.position_long

      r = @records[-1]
      @end_position_lat = r.position_lat
      @end_position_long = r.position_long
      @total_elapsed_time = r.timestamp - @start_time
      @total_timer_time = @total_elapsed_time
      @avg_speed = ((@total_distance.to_f / @total_elapsed_time) * 1000).to_i

      @max_speed = 0
      first_distance, last_distance = nil, nil
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

      end

      @total_distance = last_distance && first_distance ?
        last_distance - first_distance : 0
    end

  end

end

