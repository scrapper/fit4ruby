#!/usr/bin/env ruby -w
# encoding: UTF-8
#
# = SensorSettings.rb -- Fit4Ruby - FIT file processing library for Ruby
#
# Copyright (c) 2017 by Chris Schlaeger <cs@taskjuggler.org>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of version 2 of the GNU General Public License as
# published by the Free Software Foundation.
#

require 'fit4ruby/FitDataRecord'

module Fit4Ruby

  class SensorSettings < FitDataRecord

    def initialize(field_values = {})
      super('sensor_settings')
      set_field_values(field_values)
    end

    # Ensure that FitDataRecords have a deterministic sequence. Sensor
    # settings are sorted by message_index.
    def <=>(fdr)
      @timestamp == fdr.timestamp ?
        @message.name == fdr.message.name ?
          @message_index <=> fdr.message_index :
          RecordOrder.index(@message.name) <=>
            RecordOrder.index(fdr.message.name) :
        @timestamp <=> fdr.timestamp
    end

    def check(index)
      unless @message_index
        Log.fatal 'sensor setting record must have a message_index'
      end
    end

  end

end

