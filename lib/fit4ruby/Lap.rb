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
require 'fit4ruby/RecordAggregator'

module Fit4Ruby

  class Lap < FitDataRecord

    include RecordAggregator

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

    # Compute the average stride length for this Session.
    def avg_stride_length
      return nil unless @total_distance && @total_strides

      @total_distance / (@total_strides * 2.0)
    end

  end

end

