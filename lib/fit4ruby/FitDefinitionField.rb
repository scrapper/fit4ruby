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
require 'fit4ruby/FitDefinitionFieldBase'
require 'fit4ruby/Log'
require 'fit4ruby/GlobalFitMessage'

module Fit4Ruby

  # The FitDefinitionField models the part of the FIT file that contains the
  # template definition for a field of a FitMessageRecord. It should match the
  # corresponding definition in GlobalFitMessages. In case we don't have a
  # known entry in GlobalFitMessages we can still read the file since we know
  # the exact size of the binary records.
  class FitDefinitionField < BinData::Record

    include FitDefinitionFieldBase

    hide :reserved

    uint8 :field_definition_number
    uint8 :byte_count
    bit1 :endian_ability
    bit2 :reserved
    bit5 :base_type_number

    def init
      @global_message_number = parent.parent.global_message_number.snapshot
      @global_message_definition = GlobalFitMessages[@global_message_number]
      field_number = field_definition_number.snapshot
      if @global_message_definition &&
         (field = @global_message_definition.fields_by_number[field_number])
         @name = field.respond_to?('name') ? field.name :
                                             "choice_#{field_number}"
         @type = field.respond_to?('type') ? field.type : nil

         if @type && (td = @@TypeDefs[checked_base_type_number]) &&
            td[0] != @type
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
      if value.kind_of?(Array)
        ary = []
        value.each { |v| ary << to_machine(v) }
        ary
      else
        if @global_message_definition &&
           (field = @global_message_definition.
            fields_by_number[field_number]) &&
           field.respond_to?('to_machine')
          field.to_machine(value)
        else
          value
        end
      end
    end

    def to_s(value)
      init unless @global_message_number
      value = nil if value == undefined_value

      if value.kind_of?(Array)
        s = '[ '
        value.each { |v| s << to_s(v) + ' ' }
        s + ']'
      else
        field_number = field_definition_number.snapshot
        if @global_message_definition &&
           (field = @global_message_definition.fields_by_number[field_number])
          field.to_s(value)
        else
          "[#{value.to_s}]"
        end
      end
    end

  end

end
