#!/usr/bin/env ruby -w
# encoding: UTF-8
#
# = FitDefinitionField.rb -- Fit4Ruby - FIT file processing library for Ruby
#
# Copyright (c) 2014 by Chris Schlaeger <cs@taskjuggler.org>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of version 2 of the GNU General Public License as
# published by the Free Software Foundation.
#

require 'bindata'
require 'time'
require 'fit4ruby/Log'
require 'fit4ruby/GlobalFitMessage'

module Fit4Ruby

  class FitDefinitionField < BinData::Record

    @@TypeDefs = [
      # FIT Type, BinData type, undefined value, bytes
      [ 'enum', 'uint8', 0xFF, 1 ],
      [ 'sint8', 'int8', 0x7F, 1 ],
      [ 'uint8', 'uint8', 0xFF, 1 ],
      [ 'sint16', 'int16', 0x7FFF, 2 ],
      [ 'uint16', 'uint16', 0xFFFF, 2 ],
      [ 'sint32', 'int32', 0x7FFFFFFF, 4 ],
      [ 'uint32', 'uint32', 0xFFFFFFFF, 4 ],
      [ 'string', 'string', '', 0 ],
      [ 'float32', 'float', 0xFFFFFFFF, 4 ],
      [ 'float63', 'double', 0xFFFFFFFF, 4 ],
      [ 'uint8z', 'uint8', 0, 1 ],
      [ 'uint16z', 'uint16', 0, 2 ],
      [ 'uint32z', 'uint32', 0, 4 ],
      [ 'byte', 'uint8', 0xFF, 1 ]
    ]

    hide :reserved

    uint8 :field_definition_number
    uint8 :byte_count
    bit1 :endian_ability
    bit2 :reserved
    bit5 :base_type_number

    def self.fit_type_to_bin_data(fit_type)
      entry = @@TypeDefs.find { |e| e[0] == fit_type }
      raise "Unknown fit type #{fit_type}" unless entry
      entry[1]
    end

    def self.undefined_value(fit_type)
      entry = @@TypeDefs.find { |e| e[0] == fit_type }
      raise "Unknown fit type #{fit_type}" unless entry
      entry[2]
    end

    def init
      @global_message_number = parent.parent.global_message_number.snapshot
      @global_message_definition = GlobalFitMessages[@global_message_number]
      field_number = field_definition_number.snapshot
      if @global_message_definition &&
         (field = @global_message_definition.fields[field_number])
         @name = field.name
         @type = field.type

         if @type && (td = @@TypeDefs[base_type_number]) && td[0] != @type
           Log.warn "#{@global_message_number}:#{@name} must be of type " +
           "#{@type}, not #{td[0]}"
         end
      else
        @name = "field#{field_definition_number.snapshot}"
        @type = nil
        Log.warn { "Unknown field number #{field_definition_number} " +
                   "in global message #{@global_message_number}" }
      end
    end

    def name
      init unless @global_message_number
      @name
    end

    def to_machine(value)
      init unless @global_message_number
      value = nil if value == undefined_value

      field_number = field_definition_number.snapshot
      if @global_message_definition &&
         (field = @global_message_definition.fields[field_number])
        field.to_machine(value)
      else
        value
      end
    end

    def to_s(value)
      init unless @global_message_number
      value = nil if value == undefined_value

      field_number = field_definition_number.snapshot
      if @global_message_definition &&
         (field = @global_message_definition.fields[field_number])
        field.to_s(value)
      else
        "[#{value.to_s}]"
      end
    end

    def set_type(fit_type)
      idx = @@TypeDefs.index { |x| x[0] == fit_type }
      raise "Unknown type #{fit_type}" unless idx
      self.base_type_number = idx
      self.byte_count = @@TypeDefs[idx][3]
    end

    def type(fit_type = false)
      if @@TypeDefs.length <= base_type_number.snapshot
        Log.fatal "Unknown FIT Base type #{base_type_number.snapshot}"
      end

      @@TypeDefs[base_type_number.snapshot][fit_type ? 0 : 1]
    end

    def undefined_value
      if @@TypeDefs.length <= base_type_number.snapshot
        Log.fatal "Unknown FIT Base type #{base_type_number.snapshot}"
      end

      @@TypeDefs[base_type_number.snapshot][2]
    end

  end

end
