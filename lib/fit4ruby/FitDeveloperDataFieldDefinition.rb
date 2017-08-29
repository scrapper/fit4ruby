#!/usr/bin/env ruby -w
# encoding: UTF-8
#
# = FitDeveloperDataFieldDefinition.rb -- Fit4Ruby - FIT file processing library for Ruby
#
# Copyright (c) 2017 by Chris Schlaeger <cs@taskjuggler.org>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of version 2 of the GNU General Public License as
# published by the Free Software Foundation.
#

require 'bindata'
require 'fit4ruby/FitDefinitionFieldBase'

module Fit4Ruby

  class FitDeveloperDataFieldDefinition < BinData::Record

    include FitDefinitionFieldBase

    uint8 :field_number
    uint8 :size_in_bytes
    uint8 :developer_data_index

    def name
      "developer_field_#{developer_data_index.snapshot}_" +
        "#{field_number.snapshot}"
    end

    def bindata_type
      fit_definition = parent.parent
      if (entry = @@TypeDefs.find { |e| e[3] == size_in_bytes.snapshot })
        entry[1]
      else
        'uint8'
      end
    end

  end

end
