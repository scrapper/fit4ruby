#!/usr/bin/env ruby -w
# encoding: UTF-8
#
# = FitMessageRecord.rb -- Fit4Ruby - FIT file processing library for Ruby
#
# Copyright (c) 2014, 2015, 2018, 2019, 2020
# by Chris Schlaeger <cs@taskjuggler.org>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of version 2 of the GNU General Public License as
# published by the Free Software Foundation.
#

require 'bindata'
require 'fit4ruby/Log'
require 'fit4ruby/GlobalFitMessage'
require 'fit4ruby/FitFileEntity'
require 'fit4ruby/DumpedField'

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
        Log.debug { "Unknown global message number #{@global_message_number}" }
      end
      @message_record = produce(definition)
    end

    def read(io, entity, filter = nil, fields_dump = nil, fit_entity)
      @message_record.read(io)

      # Check if we have a developer defined message for this global message
      # number.
      if fit_entity.top_level_record
        developer_fields = fit_entity.top_level_record.field_descriptions
        @dfm = developer_fields[@global_message_number]
      end

      if @name == 'file_id'
        unless (entity_type = @message_record['type'].snapshot)
          Log.fatal "Corrupted FIT file: file_id record has no type definition"
        end
        entity.set_type(entity_type)
      end
      obj = entity.new_fit_data_record(@name)

      # It's important to ensure that alternative fields are processed after
      # the regular fields so that the decision field has already been set.
      sorted_fields = @definition.data_fields.sort do |f1, f2|
        f1alt = is_alt_field?(f1)
        f2alt = is_alt_field?(f2)
        f1alt == f2alt ?
          f1.field_definition_number.snapshot <=>
          f2.field_definition_number.snapshot :
          f1alt ? 1 : -1
      end

      #(sorted_fields + @definition.developer_fields).each do |field|
      sorted_fields.each do |field|
        value = @message_record[field.name].snapshot
        # Strings are null byte terminated. There may be more bytes in the
        # file, but we have to discard all bytes from the first null byte
        # onwards.
        if value.is_a?(String) && (null_byte = value.index("\0"))
          value = null_byte == 0 ? '' : value[0..(null_byte - 1)]
        end

        field_name, field_def = get_field_name_and_global_def(field, obj)
        obj.set(field_name, v = (field_def || field).to_machine(value)) if obj

        if filter && fields_dump &&
           (filter.field_names.nil? ||
            filter.field_names.include?(field_name)) &&
           !(((value.respond_to?('count') &&
               (value.count(field.undefined_value) == value.length)) ||
              value == field.undefined_value) && filter.ignore_undef)
          fields_dump << DumpedField.new(
            @global_message_number,
            field.field_definition_number.snapshot,
            field_name,
            field.type(true),
            (field_def ? field_def : field).to_s(value))
        end
      end

      @definition.developer_fields.each do |field|
        # Find the corresponding field description for the given developer and
        # field number.
        field_number = field.field_number.snapshot

        unless (field_description = field.find_field_definition)
          Log.error "There is no field definition for developer " +
            "#{field.developer_data_index} field #{field_number}"
          next
        end

        field_name = field_description.full_field_name
        units = field_description.units
        type = field.type
        native_message_number = field_description.native_mesg_num
        native_field_number = field_description.native_field_num

        value = @message_record[field.name].snapshot
        value = nil if value == field.undefined_value

        obj.set(field_name, value) if obj

        if filter && fields_dump &&
           (filter.field_names.nil? ||
            filter.field_names.include?(field_name)) &&
           !(((value.respond_to?('count') &&
               (value.count(field.undefined_value) == value.length)) ||
              value == field.undefined_value) && filter.ignore_undef)
          fields_dump << DumpedField.new(
            native_message_number,
            256 * (1 + field.developer_data_index) + field_number,
            field_name, type, field.to_s(value))
        end
      end

      if @name == 'field_description'
        obj.create_global_definition(fit_entity)
      end
    end

    private

    def is_alt_field?(field)
      return false unless @gfm

      field_def_number = field.field_definition_number.snapshot
      field_def = @gfm.fields_by_number[field_def_number]
      field_def.is_a?(GlobalFitMessage::AltField)
    end

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
      ref_value = obj ? obj.get(ref_field) : :default

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
      (definition.data_fields.to_a +
       definition.developer_fields.to_a).each do |field|
        field_def = [ field.type, field.name ]

        # Some field types need special handling.
        if field.type == 'string'
          # We need to also include the length of the String.
          field_def << { :read_length => field.total_bytes }
        elsif field.is_array?
          # For Arrays we have to break them into separte fields.
          field_def = [ :array, field.name,
                        { :type => field.type.intern,
                          :initial_length =>
                            field.total_bytes / field.base_type_bytes } ]
        end
        fields << field_def
      end

      BinData::Struct.new(:endian => definition.endian, :fields => fields)
    end

  end

end

