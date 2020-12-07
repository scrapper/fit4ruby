#!/usr/bin/env ruby -w
# encoding: UTF-8
#
# = Record.rb -- Fit4Ruby - FIT file processing library for Ruby
#
# Copyright (c) 2014, 2020 by Chris Schlaeger <cs@taskjuggler.org>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of version 2 of the GNU General Public License as
# published by the Free Software Foundation.
#

require 'fit4ruby/FitDataRecord'
require 'fit4ruby/FDR_DevField_Extension'

module Fit4Ruby

  # The Record corresponds to the record FIT message. A Record is a basic set
  # of primary measurements that are associated with a certain timestamp.
  class Record < FitDataRecord

    include FDR_DevField_Extension

    # Create a new Record object.
    # @param fit_entity The FitEntity this record belongs to
    # @param field_values [Hash] Hash that provides initial values for certain
    #        fields.
    def initialize(top_level_record, field_values = {})
      super('record')
      @top_level_record = top_level_record
      @meta_field_units['pace'] = 'min/km'
      @meta_field_units['run_cadence'] = 'spm'

      # Create instance variables for developer fields
      create_dev_field_instance_variables

      set_field_values(field_values)
    end

    def run_cadence
      if @cadence && @fractional_cadence
        (@cadence + @fractional_cadence) * 2
      elsif @cadence
        @cadence * 2
      else
        nil
      end
    end

    # Convert the 'speed' or 'enhanced_speed' field into a running pace. The
    # pace is measured in minutes per Kilometer.
    # @return [Float or nil] pace for this Record in m/s or nil if not
    #         available.
    def pace
      return nil unless @speed || @enhanced_speed

      1000.0 / ((@speed || @enhanced_speed) * 60.0)
    end

  end

end

