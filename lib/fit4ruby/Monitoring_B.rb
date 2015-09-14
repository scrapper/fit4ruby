#!/usr/bin/env ruby -w
# encoding: UTF-8
#
# = Monitoring_B.rb -- Fit4Ruby - FIT file processing library for Ruby
#
# Copyright (c) 2015 by Chris Schlaeger <cs@taskjuggler.org>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of version 2 of the GNU General Public License as
# published by the Free Software Foundation.
#

require 'fit4ruby/FitDataRecord'
require 'fit4ruby/FileId'
require 'fit4ruby/DeviceInfo'
require 'fit4ruby/Software'
require 'fit4ruby/MonitoringInfo'
require 'fit4ruby/Monitoring'

module Fit4Ruby

  # The Monitoring_B object is a FIT file class. It's a top-level object that
  # holds all references to other FIT records that are part of the FIT file.
  # Each of the objects it references are direct equivalents of the message
  # record structures used in the FIT file.
  class Monitoring_B < FitDataRecord

    attr_accessor :file_id, :device_infos, :software, :monitoring_infos,
                  :monitorings

    # Create a new Monitoring_B object.
    # @param field_values [Hash] A Hash that provides initial values for
    #        certain fields of the FitDataRecord.
    def initialize(field_values = {})
      super('activity')
      @num_sessions = 0

      @file_id = FileId.new
      @device_infos = []
      @softwares = nil
      @monitoring_infos = []
      @monitorings = []
    end

    # Perform some basic logical checks on the object and all references sub
    # objects. Any errors will be reported via the Log object.
    def check
      last_timestamp = ts_16_offset = nil

      # The timestamp_16 is a 2 byte time stamp value that is used instead of
      # the 4 byte timestamp field for monitoring records that have
      # current_activity_type_intensity values with an activity type of 6. The
      # value seems to be in seconds, but the 0 value reference does not seem
      # to be included in the file. However, it can be approximated using the
      # surrounding timestamp values.
      @monitorings.each do |record|
        if ts_16_offset
          # We have already found the offset. Adjust all timestamps according
          # to 'offset + timestamp_16'
          if record.timestamp_16
            record.timestamp = ts_16_offset + record.timestamp_16
          end
        else
          # We are still looking for the offset.
          if record.timestamp_16 && last_timestamp
            # We have a previous timestamp and found the first record with a
            # timestamp_16 value set. We assume that the timestamp of this
            # record is one minute after the previously found timestamp.
            # That's just a guess. Who knows what the Garmin engineers were
            # thinking here?
            ts_16_offset = last_timestamp + 60 - record.timestamp_16
            record.timestamp = ts_16_offset + record.timestamp_16
          else
            # Just save the timestamp of the current record.
            last_timestamp = record.timestamp
          end
        end
      end
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
      when 'software'
        @software = (record = Software.new(field_values))
      when 'device_info'
        @device_infos << (record = DeviceInfo.new(field_values))
      when 'monitoring_info'
        @monitoring_infos << (record = MonitoringInfo.new(field_values))
      when 'monitoring'
        @monitorings << (record = Monitoring.new(field_values))
      else
        record = nil
      end

      record
    end

  end

end

