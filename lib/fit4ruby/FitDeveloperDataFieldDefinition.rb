#!/usr/bin/env ruby -w
# encoding: UTF-8
#
# = FitDeveloperDataFieldDefinition.rb -- Fit4Ruby - FIT file processing library for Ruby
#
# Copyright (c) 2017, 2018 by Chris Schlaeger <cs@taskjuggler.org>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of version 2 of the GNU General Public License as
# published by the Free Software Foundation.
#

require 'bindata'
require 'fit4ruby/FitDefinitionFieldBase'
require 'fit4ruby/FitTypeDefs'

module Fit4Ruby

  class FitDeveloperDataFieldDefinition < BinData::Record

    include FitDefinitionFieldBase

    uint8 :field_number
    uint8 :size_in_bytes
    uint8 :developer_data_index

    def name
      "developer_field_#{developer_data_index.snapshot}_" +
        "#{field_number.snapshot}"
    end

    def type
      FIT_TYPE_DEFS[checked_base_type_number][1]
    end

    def base_type_bytes
      FIT_TYPE_DEFS[checked_base_type_number][3]
    end

    def byte_count
      size_in_bytes
    end

    def find_field_definition
      return @field_definition if @field_definition

      tlr = parent.parent.fit_entity.top_level_record
      @field_definition = tlr.field_descriptions.find do |fd|
        fd.field_definition_number == field_number.snapshot &&
          fd.developer_data_index == developer_data_index.snapshot
      end
      unless @field_definition
        Log.error "Unknown developer field #{field_number.snapshot} " +
          "for developer #{developer_data_index.snapshot}"
        return nil
      end

      @field_definition
    end

    def to_s(value)
      if (field_definition = find_field_definition)
        "#{value} #{find_field_definition.units}"
      else
        value.to_s
      end
    end

    private

    def checked_base_type_number
      field = find_field_definition
      base_type_number = field.fit_base_type_id & 0x7F
      if FIT_TYPE_DEFS.length <= base_type_number
        Log.error "Unknown FIT Base type #{base_type_number} in " +
          "Global FIT Message #{name}"
        return 0
      end

      base_type_number
    end

  end

end
