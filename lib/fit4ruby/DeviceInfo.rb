#!/usr/bin/env ruby -w
# encoding: UTF-8
#
# = DeviceInfo.rb -- Fit4Ruby - FIT file processing library for Ruby
#
# Copyright (c) 2014, 2015 by Chris Schlaeger <cs@taskjuggler.org>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of version 2 of the GNU General Public License as
# published by the Free Software Foundation.
#

require 'fit4ruby/FitDataRecord'

module Fit4Ruby

  class DeviceInfo < FitDataRecord

    def initialize(field_values = {})
      super('device_info')
      set_field_values(field_values)
    end

    # Ensure that FitDataRecords have a deterministic sequence. Device infos
    # are sorted by device_index.
    def <=>(fdr)
      @timestamp == fdr.timestamp ?
        @message.name == fdr.message.name ?
          @device_index <=> fdr.device_index :
          RecordOrder.index(@message.name) <=>
            RecordOrder.index(fdr.message.name) :
        @timestamp <=> fdr.timestamp
    end

    def check(index)
      unless @device_index
        Log.fatal 'device info record must have a device_index'
      end
      if @device_index == 0
        unless @manufacturer
          Log.fatal 'device info record 0 must have a manufacturer field set'
        end
        if @manufacturer == 'garmin'
          unless @garmin_product
            Log.fatal 'device info record 0 must have a garman_product ' +
                      'field set'
          end
        else
          unless @product
            Log.fatal 'device info record 0 must have a product field set'
          end
        end
        if @serial_number.nil?
          Log.fatal 'device info record 0 must have a serial number set'
        end
      end
    end

  end

end

