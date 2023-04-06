#!/usr/bin/env ruby -w
# encoding: UTF-8
#
# = FitDataRecord.rb -- Fit4Ruby - FIT file processing library for Ruby
#
# Copyright (c) 2014, 2015, 2020, 2021 by Chris Schlaeger <cs@taskjuggler.org>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of version 2 of the GNU General Public License as
# published by the Free Software Foundation.
#

require 'fit4ruby/FitMessageIdMapper'
require 'fit4ruby/GlobalFitMessages.rb'
require 'fit4ruby/BDFieldNameTranslator'

module Fit4Ruby

  class FitDataRecord

    include Converters
    include BDFieldNameTranslator

    RecordOrder = [ 'user_data', 'user_profile', 'workout', 'workout_set',
                    'device_info', 'data_sources', 'event',
                    'record', 'lap', 'length', 'session', 'heart_rate_zones',
                    'personal_records' ]

    attr_reader :message, :timestamp

    def initialize(record_id)
      @message = GlobalFitMessages.find_by_name(record_id)

      # Create instance variables that correspond to every field of the
      # corresponding FIT data record.
      @message.fields_by_name.each do |name, field|
        create_instance_variable(name)
      end

      # Meta fields are additional fields that are not part of the FIT
      # specification but are convenient to have. These are typcially
      # aggregated or converted values of regular fields.
      @meta_field_units = {}
      @timestamp = Time.now
    end

    def set_field_values(field_values)
      field_values.each do |field, value|
        set(field.to_s, value)
      end
    end

    def set(name, value)
      ivar_name = '@' + name
      unless instance_variable_defined?(ivar_name)
        Log.debug("Unknown FIT record field '#{name}' in global message " +
                  "#{@message.name} (#{@message.number}).")
        return
      end
      instance_variable_set(ivar_name, value)
    end

    def get(name)
      # This is a request for a native FIT field.
      ivar_name = '@' + name
      return nil unless instance_variable_defined?(ivar_name)

      instance_variable_get(ivar_name)
    end

    def get_as(name, to_unit)
      value = respond_to?(name) ? send(name) : get(name)
      return nil if value.nil?
      # If the requested unit is empty we return the value as is.
      return value if to_unit.nil? || to_unit.empty?

      if @meta_field_units.include?(name)
        unit = @meta_field_units[name]
      else
        unless (unit = get_unit_by_name(name))
          Log.fatal "Field #{name} has no unit"
        end
      end

      value = convert_value(value, unit, to_unit)
    end

    def ==(fdr)
      @message.each_field(field_values_as_hash) do |number, field|
        ivar_name = '@' + field.name
        # Comparison of values is done in the fit file format as the accuracy
        # of native formats is better and could lead to wrong results if a
        # value hasn't been read back from a fit file yet.
        v1 = field.native_to_fit(instance_variable_get(ivar_name))
        v2 = field.native_to_fit(fdr.instance_variable_get(ivar_name))

        return false unless v1 == v2
      end

      true
    end

    def <=>(fdr)
      @timestamp == fdr.timestamp ?
        RecordOrder.index(@message.name) <=>
        RecordOrder.index(fdr.message.name) :
        @timestamp <=> fdr.timestamp
    end

    def write(io, id_mapper)
      global_fit_message = @message.construct(
        field_values = field_values_as_hash)

      # Map the global message number to the current local message number.
      unless (local_message_number = id_mapper.get_local(global_fit_message))
        # If the current dictionary does not contain the global message
        # number, we need to create a new entry for it. The index in the
        # dictionary is the local message number.
        local_message_number = id_mapper.add_global(global_fit_message)
        # Write the definition of the global message number to the file.
        global_fit_message.write(io, local_message_number)
      end

      # Write data record header.
      header = FitRecordHeader.new
      header.normal = 0
      header.message_type = 0
      header.local_message_type = local_message_number
      header.write(io)

      # Create a BinData::Struct object to store the data record.
      fields = []
      values = {}

      # Fill the BinData::Struct object with the values from the corresponding
      # instance variables.
      global_fit_message.each_field(field_values) do |number, field|
        bin_data_type = FitDefinitionFieldBase.fit_type_to_bin_data(field.type)
        field_name = to_bd_field_name(field.name)
        field_def = [ bin_data_type, field_name ]

        iv = "@#{field.name}"
        if instance_variable_defined?(iv) &&
           !(iv_value = instance_variable_get(iv)).nil?
          values[field.name] = field.native_to_fit(iv_value)
        else
          # If we don't have a corresponding variable or the variable is nil
          # we write the 'undefined' value instead.
          value = FitDefinitionFieldBase.undefined_value(field.type)
          values[field.name] = field.opts[:array] ? [ value ] :
            field.type == 'string' ? '' : value
        end

        # Some field types need special handling.
        if field.type == 'string'
          # Zero terminate the string.
          values[field.name] += "\0"
        elsif field.opts[:array]
          # For Arrays we use a BinData::Array to write them.
          field_def = [ :array, field_name,
                        { :type => bin_data_type,
                          :initial_length => values[field.name].size } ]
        end
        fields << field_def
      end
      bd = BinData::Struct.new(:endian => :little, :fields => fields)

      # Fill the BinData::Struct object with the values from the corresponding
      # instance variables.
      global_fit_message.each_field(field_values) do |number, field|
        bd[to_bd_field_name(field.name)] = values[field.name]
      end

      # Write the data record to the file.
      bd.write(io)
    end

    def export
      message = {
        'message' => @message.name,
        'number' => @message.number,
        'fields' => {}
      }

      @message.each_field(field_values_as_hash) do |number, field|
        ivar_name = '@' + field.name
        fit_value = field.native_to_fit(instance_variable_get(ivar_name))
        unless field.is_undefined?(fit_value)
          fld = {
            'number' => number,
            'value' => field.fit_to_native(fit_value),
            #'human' => field.to_human(fit_value),
            'type' => field.type
          }
          fld['unit'] = field.opts[:unit] if field.opts[:unit]
          fld['scale'] = field.opts[:scale] if field.opts[:scale]

          message['fields'][field.name] = fld
        end
      end

      message
    end

    def get_unit_by_name(name)
      field = @message.fields_by_name[name]
      field.opts[:unit]
    end

    private

    def field_values_as_hash
      # Construct a GlobalFitMessage object that matches exactly the provided
      # set of fields. It does not contain any AltField objects.
      field_values = {}
      @message.fields_by_name.each_key do |name|
        field_values[name] = instance_variable_get('@' + name)
      end

      field_values
    end

    def create_instance_variable(name)
      # Create a new instance variable for 'name'. We initialize it with a
      # provided default value or nil.
      instance_variable_set('@' + name, nil)
      # And create an accessor method for it as well.
      self.class.__send__(:attr_accessor, name)
    end

  end

end

