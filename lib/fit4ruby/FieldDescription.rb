#!/usr/bin/env ruby -w
# encoding: UTF-8
#
# = FieldDescription.rb -- Fit4Ruby - FIT file processing library for Ruby
#
# Copyright (c) 2017, 2018, 2019 by Chris Schlaeger <cs@taskjuggler.org>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of version 2 of the GNU General Public License as
# published by the Free Software Foundation.
#

require 'fit4ruby/FitDataRecord'
require 'fit4ruby/FitDefinitionFieldBase'
require 'fit4ruby/FitTypeDefs'

module Fit4Ruby

  # This class corresponds to the FieldDescription FIT message.
  class FieldDescription < FitDataRecord

    # Create a new FieldDescription object.
    # @param field_values [Hash] Hash that provides initial values for certain
    #        fields.
    def initialize(field_values = {})
      super('field_description')
      set_field_values(field_values)
    end

    def create_global_definition(fit_entity)
      messages = fit_entity.developer_fit_messages
      unless (gfm = GlobalFitMessages[@native_mesg_num])
        Log.error "Developer field description references unknown global " +
          "message number #{@native_mesg_num}"
        return
      end

      if @developer_data_index >=
           fit_entity.top_level_record.developer_data_ids.size
         Log.error "Developer data index #{@developer_data_index} is too large"
         return
      end

      msg = messages[@native_mesg_num] ||
        messages.message(@native_mesg_num, gfm.name)
      unless (@fit_base_type_id & 0x7F) < FIT_TYPE_DEFS.size
        Log.error "fit_base_type_id #{@fit_base_type_id} is too large"
        return
      end

      name = "_#{@developer_data_index}_#{@field_name}"
      # A fit file may include multiple definitions of the same field. We
      # ignore all subsequent definitions.
      return if msg.has_field?(name)

      options = {}
      options[:scale] = @scale if @scale
      options[:offset] = @offset if @offset
      options[:array] = @array if @array
      options[:unit] = @units
      msg.field(@field_definition_number,
                FIT_TYPE_DEFS[@fit_base_type_id & 0x7F][1],
                name, options)
    end

  end

end

