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

module Fit4Ruby

  class FitDefinition < BinData::Record

    hide :reserved

    uint8 :reserved, :initial_value => 0
    uint8 :architecture, :initial_value => 0
    choice :global_message_number, :selection => :architecture do
      uint16le 0
      uint16be :default
    end
    uint8 :field_count
    array :fields, :type => FitDefinitionField, :initial_length => :field_count

    def endian
      architecture.snapshot == 0 ? :little : :big
    end

    def check
      fields.each { |f| f.check }
    end

    def setup(fit_message_definition)
      fit_message_definition.fields.each do |number, f|
        fdf = FitDefinitionField.new
        fdf.field_definition_number = number
        fdf.set_type(f.type)

        fields << fdf
      end
      self.field_count = fields.length
    end

  end


end

