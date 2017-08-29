#!/usr/bin/env ruby -w
# encoding: UTF-8
#
# = FitDefinitionFieldBase.rb -- Fit4Ruby - FIT file processing library for Ruby
#
# Copyright (c) 2014, 2017 by Chris Schlaeger <cs@taskjuggler.org>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of version 2 of the GNU General Public License as
# published by the Free Software Foundation.
#

module Fit4Ruby

  module FitDefinitionFieldBase

    @@TypeDefs = [
      # FIT Type, BinData type, undefined value, bytes
      [ 'enum', 'uint8', 0xFF, 1 ],
      [ 'sint8', 'int8', 0x7F, 1 ],
      [ 'uint8', 'uint8', 0xFF, 1 ],
      [ 'sint16', 'int16', 0x7FFF, 2 ],
      [ 'uint16', 'uint16', 0xFFFF, 2 ],
      [ 'sint32', 'int32', 0x7FFFFFFF, 4 ],
      [ 'uint32', 'uint32', 0xFFFFFFFF, 4 ],
      [ 'string', 'string', '', 0 ],
      [ 'float32', 'float', 0xFFFFFFFF, 4 ],
      [ 'float63', 'double', 0xFFFFFFFF, 4 ],
      [ 'uint8z', 'uint8', 0, 1 ],
      [ 'uint16z', 'uint16', 0, 2 ],
      [ 'uint32z', 'uint32', 0, 4 ],
      [ 'byte', 'uint8', 0xFF, 1 ],
      [ 'sint64', 'int64', 0x7FFFFFFFFFFFFFFF, 8 ],
      [ 'uint64', 'uint64', 0xFFFFFFFFFFFFFFFF, 8 ],
      [ 'uint64z', 'uint64', 0, 8 ]
    ]

    def FitDefinitionFieldBase::fit_type_to_bin_data(fit_type)
      entry = @@TypeDefs.find { |e| e[0] == fit_type }
      raise "Unknown fit type #{fit_type}" unless entry
      entry[1]
    end

    def FitDefinitionFieldBase::undefined_value(fit_type)
      entry = @@TypeDefs.find { |e| e[0] == fit_type }
      raise "Unknown fit type #{fit_type}" unless entry
      entry[2]
    end

    def set_type(fit_type)
      idx = @@TypeDefs.index { |x| x[0] == fit_type }
      raise "Unknown type #{fit_type}" unless idx
      self.base_type_number = idx
      self.byte_count = @@TypeDefs[idx][3]
    end

    def type(fit_type = false)
      @@TypeDefs[checked_base_type_number][fit_type ? 0 : 1]
    end

    def is_array?
      if total_bytes > base_type_bytes
        if total_bytes % base_type_bytes != 0
          Log.error "Total bytes (#{total_bytes}) must be multiple of " +
                    "base type bytes (#{base_type_bytes}) of type " +
                    "#{base_type_number.snapshot} in Global FIT " +
                    "Message #{name}."
        end
        return true
      end
      false
    end

    def total_bytes
      self.byte_count.snapshot
    end

    def base_type_bytes
      @@TypeDefs[checked_base_type_number][3]
    end

    def undefined_value
      @@TypeDefs[checked_base_type_number][2]
    end

    private

    def checked_base_type_number
      if @@TypeDefs.length <= base_type_number.snapshot
        Log.error "Unknown FIT Base type #{base_type_number.snapshot} in " +
          "Global FIT Message #{name}"
        return 0
      end
      base_type_number.snapshot
    end

    def check_fit_base_type
      if @@TypeDefs.length <= base_type_number.snapshot
      end
    end

  end

end

