#!/usr/bin/env ruby -w
# encoding: UTF-8
#
# = FitDefinition.rb -- Fit4Ruby - FIT file processing library for Ruby
#
# Copyright (c) 2014 by Chris Schlaeger <cs@taskjuggler.org>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of version 2 of the GNU General Public License as
# published by the Free Software Foundation.
#

require 'bindata'
require 'fit4ruby/FitDefinitionField'
require 'fit4ruby/FitDeveloperDataFieldDefinition'

module Fit4Ruby

  # The FitDefinition contains the blueprints for FitMessageRecord segments of
  # FIT files. Before a message record can occur in a FIT file, its definition
  # must be included in the FIT file. The definition holds enough information
  # about the message record to define its size. It also contains some basic
  # information how to interpret the data in the record. To fully understand
  # the message record data the full definition in the GlobalFitMessage is
  # required.
  class FitDefinition < BinData::Record

    @@has_developer_data = false

    hide :reserved

    uint8 :reserved, :initial_value => 0
    uint8 :architecture, :initial_value => 0
    choice :global_message_number, :selection => :architecture do
      uint16le 0
      uint16be :default
    end
    uint8 :field_count
    array :data_fields, :type => FitDefinitionField,
      :initial_length => :field_count

    uint8 :developer_fields_count, :onlyif => :has_developer_data?
    array :developer_fields,
      :type => FitDeveloperDataFieldDefinition,
      :initial_length => :developer_fields_count,
      :onlyif => :has_developer_data?

    def endian
      architecture.snapshot == 0 ? :little : :big
    end

    def check
      if architecture.snapshot > 1
        Log.fatal "Illegal architecture value #{architecture.snapshot}"
      end
      data_fields.each { |f| f.check }
      developer_fields.each { |f| f.check }
    end

    def FitDefinition::read(io, entity, developer_data_flag, fit_entity)
      @@has_developer_data = developer_data_flag != 0
      @@fit_entity = fit_entity
      super(io)
    end

    def FitDefinitionField::write(io)
      # We don't support writing developer data fields yet.
      @@has_developer_data = false
      super(io)
    end

    def has_developer_data?
      @@has_developer_data
    end

    def fit_entity
      @@fit_entity
    end

    def setup(fit_message_definition)
      fit_message_definition.fields_by_number.each do |number, f|
        fdf = FitDefinitionField.new
        fdf.field_definition_number = number
        fdf.set_type(f.type)

        data_fields << fdf
      end
      self.field_count = data_fields.length
    end

  end

end

