#!/usr/bin/env ruby -w
# encoding: UTF-8
#
# = Lap.rb -- Fit4Ruby - FIT file processing library for Ruby
#
# Copyright (c) 2014, 2015 by Chris Schlaeger <cs@taskjuggler.org>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of version 2 of the GNU General Public License as
# published by the Free Software Foundation.
#

require 'fit4ruby/FitDataRecord'
require 'fit4ruby/RecordAggregator'
require 'fit4ruby/FDR_DevField_Extension'

module Fit4Ruby

  class Lap < FitDataRecord

    include RecordAggregator
    include FDR_DevField_Extension

    attr_reader :records, :lengths

    # Create a new Lap object.
    # @param top_level_record [FitDataRecord] Top level record that is Lap
    #        belongs to.
    # @param records [Array of Records] Records to associate with the Lap.
    # @param lengths [Array of Lengths] Lengths to associate with the Lap.
    # @param first_length_index [Fixnum] Index of the first Length in this Lap.
    # @param previous_lap [Lap] Previous Lap on same Session.
    # @param field_values [Hash] Hash that provides initial values for certain
    #        fields.
    def initialize(top_level_record, records, previous_lap, field_values,
                   first_length_index, lengths)
      super('lap')
      @top_level_record = top_level_record
      @lengths = lengths
      @meta_field_units['avg_stride_length'] = 'm'
      @records = records
      @previous_lap = previous_lap
      @lengths.each { |length| @records += length.records }
      @first_length_index = first_length_index
      @num_lengths = @lengths.length

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

      # Create instance variables for developer fields
      create_dev_field_instance_variables

      set_field_values(field_values)
    end

    def check(index, activity)
      unless @message_index == index
        Log.fatal "message_index must be #{index}, not #{@message_index}"
      end

      return if @num_lengths.zero?

      unless @first_length_index
        Log.fatal 'first_length_index is not set'
      end

      @first_length_index.upto(@first_length_index - @num_lengths) do |i|
        if (length = activity.lengths[i])
          @lengths << length
        else
          Log.fatal "Lap references length #{i} which is not contained in "
          "the FIT file."
        end
      end
    end

    # Compute the average stride length for this Session.
    def avg_stride_length
      return nil unless @total_distance && @total_strides

      @total_distance / (@total_strides * 2.0)
    end

  end

end

