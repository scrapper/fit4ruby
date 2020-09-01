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

    def numeric_manufacturer
      if @manufacturer && @manufacturer.is_a?(String)
        if @manufacturer[0..17] == 'Undocumented value'
          return @manufacturer[18..-1].to_i
        else
          return GlobalFitDictionaries['manufacturer'].
            value_by_name(@manufacturer)
        end
      end

      Log.fatal "Unexpected @manufacturer (#{@manufacturer}) value"
    end

    def numeric_product
      # The numeric product ID must be an integer or nil. In case the
      # dictionary did not contain an entry for the numeric ID in the fit file
      # the @garmin_product or @product variables contain a String starting
      # with 'Undocumented value ' followed by the ID.
      if @garmin_product && @garmin_product.is_a?(String)
        if @garmin_product[0..17] == 'Undocumented value'
          return @garmin_product[18..-1].to_i
        else
          return GlobalFitDictionaries['garmin_product'].
            value_by_name(@garmin_product)
        end
      elsif @product && @product.is_a?(String)
        if @product[0..17] == 'Undocumented value'
          return @product[18..-1].to_i
        else
          return GlobalFitDictionaries['product'].value_by_name(@product)
        end
      end

      Log.fatal "Unexpected @product (#{@product}) or " +
        "@garmin_product (#{@garmin_product}) values"
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

