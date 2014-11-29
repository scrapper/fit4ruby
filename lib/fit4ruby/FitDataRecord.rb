#!/usr/bin/env ruby -w
# encoding: UTF-8
#
# = FitDataRecord.rb -- Fit4Ruby - FIT file processing library for Ruby
#
# Copyright (c) 2014 by Chris Schlaeger <cs@taskjuggler.org>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of version 2 of the GNU General Public License as
# published by the Free Software Foundation.
#

require 'fit4ruby/FitMessageIdMapper'
require 'fit4ruby/GlobalFitMessages.rb'

module Fit4Ruby

  class FitDataRecord

    include Converters

    def initialize(record_id)
      @message = GlobalFitMessages.find_by_name(record_id)

      # Create instance variables that correspond to every field of the
      # corresponding FIT data record.
      @message.fields.each do |field_number, field|
        create_instance_variable(field.name)
      end
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
        Log.warn("Unknown FIT record field '#{name}' in global message " +
                 "#{@message.name} (#{@message.number}).")
        return
      end
      instance_variable_set('@' + name, value)
    end

    def get(name)
      ivar_name = '@' + name
      return nil unless instance_variable_defined?(ivar_name)

      instance_variable_get('@' + name)
    end

    def get_as(name, to_unit)
      value = respond_to?(name) ? send(name) : get(name)
      return nil if value.nil?

      if @meta_field_units.include?(name)
        unit = @meta_field_units[name]
      else
        field = @message.find_by_name(name)
        unless (unit = field.opts[:unit])
          Log.fatal "Field #{name} has no unit"
        end
      end

      value * conversion_factor(unit, to_unit)
    end

    def ==(fdr)
      @message.fields.each do |field_number, field|
        ivar_name = '@' + field.name
        v1 = field.fit_to_native(field.native_to_fit(
          instance_variable_get(ivar_name)))
        v2 = field.fit_to_native(field.native_to_fit(
          fdr.instance_variable_get(ivar_name)))

        unless v1 == v2
          Log.error "#{field.name}: #{v1} != #{v2}"
          return false
        end
      end

      true
    end

    def <=>(fdr)
      @timestamp <=> fdr.timestamp
    end

    def write(io, id_mapper)
      global_message_number = @message.number

      # Map the global message number to the current local message number.
      unless (local_message_number = id_mapper.get_local(global_message_number))
        # If the current dictionary does not contain the global message
        # number, we need to create a new entry for it. The index in the
        # dictionary is the local message number.
        local_message_number = id_mapper.add_global(global_message_number)
        # Write the definition of the global message number to the file.
        @message.write(io, local_message_number)
      end

      # Write data record header.
      header = FitRecordHeader.new
      header.normal = 0
      header.message_type = 0
      header.local_message_type = local_message_number
      header.write(io)

      # Create a BinData::Struct object to store the data record.
      fields = []
      @message.fields.each do |field_number, field|
        bin_data_type = FitDefinitionField.fit_type_to_bin_data(field.type)
        fields << [ bin_data_type, field.name ]
      end
      bd = BinData::Struct.new(:endian => :little, :fields => fields)

      # Fill the BinData::Struct object with the values from the corresponding
      # instance variables.
      @message.fields.each do |field_number, field|
        iv = "@#{field.name}"
        if instance_variable_defined?(iv) &&
           !(iv_value = instance_variable_get(iv)).nil?
          value = field.native_to_fit(iv_value)
        else
          # If we don't have a corresponding variable or the variable is nil
          # we write the 'undefined' value instead.
          value = FitDefinitionField.undefined_value(field.type)
        end
        bd[field.name] = value
      end

      # Write the data record to the file.
      bd.write(io)
    end

    def inspect
      fields = {}
      @message.fields.each do |field_number, field|
        ivar_name = '@' + field.name
        fields[field.name] = instance_variable_get(ivar_name)
      end
      fields.inspect
    end

    private

    def create_instance_variable(name)
      # Create a new instance variable for 'name'. We initialize it with a
      # provided default value or nil.
      instance_variable_set('@' + name, nil)
      # And create an accessor method for it as well.
      self.class.__send__(:attr_accessor, name)
    end

  end

end

