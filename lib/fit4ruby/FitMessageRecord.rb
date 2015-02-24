#!/usr/bin/env ruby -w
# encoding: UTF-8
#
# = FitMessageRecord.rb -- Fit4Ruby - FIT file processing library for Ruby
#
# Copyright (c) 2014 by Chris Schlaeger <cs@taskjuggler.org>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of version 2 of the GNU General Public License as
# published by the Free Software Foundation.
#

require 'bindata'
require 'fit4ruby/Log'
require 'fit4ruby/GlobalFitMessage'

module Fit4Ruby

  # The FitMessageRecord models a part of the FIT file that contains the
  # FIT message records. Each message record has a number, a local type and a
  # set of data fields. The content of a FitMessageRecord is defined by the
  # FitDefinition. This class is only used for reading data from a FIT file.
  # For writing FIT message records, the class FitDataRecord and its
  # decendents are used.
  class FitMessageRecord

    attr_reader :global_message_number, :name, :message_record

    def initialize(definition)
      @definition = definition
      @global_message_number = definition.global_message_number.snapshot

      if (@gfm = GlobalFitMessages[@global_message_number])
        @name = @gfm.name
      else
        @name = "message#{@global_message_number}"
        Log.warn { "Unknown global message number #{@global_message_number}" }
      end
      @message_record = produce(definition)
    end

    def read(io, activity, filter = nil, fields_dump = nil)
      @message_record.read(io)

      obj = @name == 'activity' ? activity : activity.new_fit_data_record(@name)

      # It's important to ensure that fields are sorted by their definition
      # number so that alternative fields are always processed after their
      # selection fields have been processed.
      sorted_fields = @definition.fields.sort do |f1, f2|
        f1.field_definition_number.snapshot <=>
        f2.field_definition_number.snapshot
      end

      sorted_fields.each do |field|
        value = @message_record[field.name].snapshot
        # Strings are null byte terminated. There may be more bytes in the
        # file, but we have to discard all bytes from the first null byte
        # onwards.
        if value.is_a?(String) && (null_byte = value.index("\0"))
          value = value[0..(null_byte - 1)]
        end

        field_name, field_def = get_field_name_and_global_def(field, obj)
        obj.set(field_name, field.to_machine(value)) if obj
        if filter && fields_dump &&
           (filter.field_names.nil? ||
            filter.field_names.include?(field_name)) &&
           (value != field.undefined_value || !filter.ignore_undef)
          fields_dump << [ field.type(true), field_name,
                           (field_def ? field_def : field).to_s(value) ]
        end
      end
    end

    private

    def get_field_name_and_global_def(field, obj)
      # If we don't have a corresponding GlobalFitMessage definition, we can't
      # tell if the field is an alternative or not. We don't treat it as such.
      return [ field.name, nil ] unless @gfm

      field_def_number = field.field_definition_number.snapshot
      # Get the corresponding GlobalFitMessage field definition.
      field_def = @gfm.fields_by_number[field_def_number]
      # If it's not an AltField, we just use the already given name.
      unless field_def.is_a?(GlobalFitMessage::AltField)
        return [ field.name, nil ]
      end

      # We have an AltField. Now we need to find the selection field and its
      # value.
      ref_field = field_def.ref_field
      ref_value = obj.get(ref_field)

      # Based on that value, we select the Field of the AltField.
      selected_field = field_def.fields[ref_value] ||
                       field_def.fields[:default]
      Log.fatal "The value #{ref_value} of field #{ref_field} does not match " +
                "any selection of alternative field #{field_def_number} in " +
                "GlobalFitMessage #{@gfm.name}" unless selected_field

      [ selected_field.name, selected_field ]
    end

    def produce(definition)
      fields = []
      definition.fields.each do |field|
        field_def = [ field.type, field.name ]
        if field.type == 'string'
          # Strings need special handling. We need to also include the length
          # of the String.
          field_def << { :read_length => field.total_bytes }
        elsif field.is_array?
          field_def = [ :array, field.name,
                        { :type => field.type.intern,
                          :initial_length => field.total_bytes /
                                             field.base_type_bytes } ]
        end
        fields << field_def
      end

      BinData::Struct.new(:endian => definition.endian, :fields => fields)
    end

  end

end

