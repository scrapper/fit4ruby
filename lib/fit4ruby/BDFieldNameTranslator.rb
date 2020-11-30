#!/usr/bin/env ruby -w
# encoding: UTF-8
#
# = FitDataRecord.rb -- Fit4Ruby - FIT file processing library for Ruby
#
# Copyright (c) 2020 by Chris Schlaeger <cs@taskjuggler.org>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of version 2 of the GNU General Public License as
# published by the Free Software Foundation.
#

module Fit4Ruby

  # Some FIT message field names conflict with BinData reserved names. We use
  # this translation method to map the conflicting names to BinData compatible
  # names.
  module BDFieldNameTranslator

    BD_DICT =  {
      'array' => '_array',
      'type' => '_type'
    }

    def to_bd_field_name(name)
      if (bd_name = BD_DICT[name])
        return bd_name
      end

      name
    end

  end

end

