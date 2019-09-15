#!/usr/bin/env ruby -w
# encoding: UTF-8
#
# = Length.rb -- Fit4Ruby - FIT file processing library for Ruby
#
# Copyright (c) 2014, 2015 by Chris Schlaeger <cs@taskjuggler.org>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of version 2 of the GNU General Public License as
# published by the Free Software Foundation.
#

require 'fit4ruby/FitDataRecord'
require 'fit4ruby/RecordAggregator'

module Fit4Ruby

  class Length < FitDataRecord

    include RecordAggregator

    attr_reader :records

    def initialize(records, previous_length, field_values)
      super('length')
      @records = records
      @previous_length = previous_length

      if previous_length && previous_length.records && previous_length.records.last
        # Set the start time of the new length to the timestamp of the last record
        # of the previous length.
        @start_time = previous_length.records.last.timestamp
      elsif records.first
        # Or to the timestamp of the first record.
        @start_time = records.first.timestamp
      end

      if records.last
        @total_elapsed_time = records.last.timestamp - @start_time
      end

      set_field_values(field_values)
    end

    def check(index)
      unless @message_index == index
        Log.fatal "message_index must be #{index}, not #{@message_index}"
      end
    end

  end

end
