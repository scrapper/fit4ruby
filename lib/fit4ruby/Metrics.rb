#!/usr/bin/env ruby -w
# encoding: UTF-8
#
# = Metrics.rb -- Fit4Ruby - FIT file processing library for Ruby
#
# Copyright (c) 2018 by Chris Schlaeger <cs@taskjuggler.org>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of version 2 of the GNU General Public License as
# published by the Free Software Foundation.
#

require 'fit4ruby/FitDataRecord'
require 'fit4ruby/FileId'
require 'fit4ruby/FileCreator'
require 'fit4ruby/DeviceInfo'
require 'fit4ruby/TrainingStatus'

module Fit4Ruby

  # The Metrics object is a FIT file class. It's a top-level object that
  # holds all references to other FIT records that are part of the FIT file.
  # Each of the objects it references are direct equivalents of the message
  # record structures used in the FIT file.
  #
  # This is not part of the officially documented FIT API. Names may change in
  # the future if the real Garmin names get known.
  class Metrics < FitDataRecord

    attr_accessor :field_descriptions, :file_id, :file_creator, :device_infos

    # Create a new Metrics object.
    # @param field_values [Hash] A Hash that provides initial values for
    #        certain fields of the FitDataRecord.
    def initialize(field_values = {})
      super('metrics')

      @field_descriptions = []

      @file_id = FileId.new
      @device_infos = []
      @file_creator = nil
      @training_statuses = []
    end

    # Perform some basic logical checks on the object and all references sub
    # objects. Any errors will be reported via the Log object.
    def check
    end

    # Create a new FitDataRecord.
    # @param record_type [String] Type that identifies the FitDataRecord
    #        derived class to create.
    # @param field_values [Hash] A Hash that provides initial values for
    #        certain fields of the FitDataRecord.
    # @return FitDataRecord
    def new_fit_data_record(record_type, field_values = {})
      case record_type
      when 'file_id'
        @file_id = (record = FileId.new(field_values))
      when 'file_creator'
        @software = (record = FileCreator.new(field_values))
      when 'device_info'
        @device_infos << (record = DeviceInfo.new(field_values))
      when 'training_status'
        @training_statuses << (record = TrainingStatus.new(field_values))
      else
        record = nil
      end

      record
    end

  end

end


