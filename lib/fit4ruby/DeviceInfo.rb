#!/usr/bin/env ruby -w
# encoding: UTF-8
#
# = DeviceInfo.rb -- Fit4Ruby - FIT file processing library for Ruby
#
# Copyright (c) 2014 by Chris Schlaeger <cs@taskjuggler.org>
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

    def check(index)
      unless @device_index
        Log.critical 'device info record must have a device_index'
      end
      if @device_index == 0
        unless @manufacturer
          Log.critical 'device info record 0 must have a manufacturer field set'
        end
        if @manufacturer == 'garmin'
          unless @garmin_product
            Log.critical 'device info record 0 must have a garman_product ' +
                         'field set'
          end
        else
          unless @product
            Log.critical 'device info record 0 must have a product field set'
          end
        end
        if @serial_number.nil?
          Log.critical 'device info record 0 must have a serial number set'
        end
      end
    end

  end

end

