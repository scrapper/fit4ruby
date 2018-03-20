#!/usr/bin/env ruby -w
# encoding: UTF-8
#
# = FitHeader.rb -- Fit4Ruby - FIT file processing library for Ruby
#
# Copyright (c) 2014, 2015, 2016, 2017, 2018
#   by Chris Schlaeger <cs@taskjuggler.org>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of version 2 of the GNU General Public License as
# published by the Free Software Foundation.
#

require 'bindata'
require 'fit4ruby/Log'
require 'fit4ruby/CRC16'

module Fit4Ruby

  class FitHeader < BinData::Record

    include CRC16

    endian :little

    uint8 :header_size, :initial_value => 14
    uint8 :protocol_version, :initial_value => 16
    uint16 :profile_version, :initial_value => 1012
    uint32 :data_size, :initial_value => 0
    string :data_type, :read_length => 4, :initial_value => '.FIT'
    uint16 :crc, :initial_value => 0, :onlyif => :has_crc?

    def read(io)
      super

      unless header_size.snapshot == 12 || header_size.snapshot == 14
        Log.fatal "Unsupported header size #{header_size.snapshot}"
      end
      unless data_type.snapshot == '.FIT'
        Log.fatal "Unknown file type #{data_type.snapshot}"
      end
      if crc.snapshot != 0 &&
         compute_crc(io, 0, header_size.snapshot - 2) != crc.snapshot
        Log.fatal "CRC mismatch in header."
      end
    end

    def write(io)
      super

      write_crc(io, 0, header_size.snapshot - 2)
    end

    def dump
      puts <<"EOT"
Fit File Header
  Header Size: #{header_size.snapshot}
  Protocol Version: #{protocol_version.snapshot}
  Profile Version: #{profile_version.snapshot}
  Data Size: #{data_size.snapshot}
EOT
    end

    def has_crc?
      header_size.snapshot == 14
    end

    def end_pos
      header_size.snapshot  + data_size.snapshot
    end

  end

end

