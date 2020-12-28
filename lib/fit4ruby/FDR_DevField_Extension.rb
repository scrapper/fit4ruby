#!/usr/bin/env ruby -w
# encoding: UTF-8
#
# = FDR_DevField_Extension.rb -- Fit4Ruby - FIT file processing library for Ruby
#
# Copyright (c) 2020 by Chris Schlaeger <cs@taskjuggler.org>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of version 2 of the GNU General Public License as
# published by the Free Software Foundation.
#

module Fit4Ruby

  # This module extends FitDataRecord derived classes in case they have
  # developer fields.
  module FDR_DevField_Extension

    def create_dev_field_instance_variables
      # Create instance variables for developer fields
      @dev_field_descriptions = {}
      @top_level_record.field_descriptions.each do |field_description|
        # Only create instance variables if the FieldDescription is for this
        # message number.
        if field_description.native_mesg_num == @message.number
          name = field_description.full_field_name(@top_level_record.
                                                   developer_data_ids)
          create_instance_variable(name)
          @dev_field_descriptions[name] = field_description
        end
      end
    end

    def each_developer_field
      @top_level_record.field_descriptions.each do |field_description|
        # Only create instance variables if the FieldDescription is for this
        # message number.
        if field_description.native_mesg_num == @message.number
          name = field_description.full_field_name(@top_level_record.
                                                   developer_data_ids)
          yield(field_description, instance_variable_get('@' + name))
        end
      end
    end

    def get_unit_by_name(name)
      if /[A-Za-z_]+_[A-F0-9]{16}/ =~ name
        @dev_field_descriptions[name].units
      else
        super
      end
    end

    def export
      message = super

      each_developer_field do |field_description, ivar|
        field = field_description.message.fields_by_number[
          field_description.native_field_num]
        fit_value = field.native_to_fit(ivar)
        unless field.is_undefined?(fit_value)
          fld = {
            'number' => field_description.native_field_num | 128,
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

  end

end

