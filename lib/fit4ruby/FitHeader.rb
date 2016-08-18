#!/usr/bin/env ruby -w
# encoding: UTF-8
#
# = FitHeader.rb -- Fit4Ruby - FIT file processing library for Ruby
#
# Copyright (c) 2014 by Chris Schlaeger <cs@taskjuggler.org>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of version 2 of the GNU General Public License as
# published by the Free Software Foundation.
#

require 'bindata'
require 'fit4ruby/Log'

module Fit4Ruby

  class FitHeader < BinData::Record

    endian :little

    uint8 :header_size, :initial_value => 14
    uint8 :protocol_version, :initial_value => 16
    uint16 :profile_version, :initial_value => 1012
    uint32 :data_size, :initial_value => 0
    string :data_type, :read_length => 4, :initial_value => '.FIT'
    uint16 :crc, :initial_value => 0

    def check
      unless header_size == 14
        Log.fatal { "Unsupported header size #{@header.header_size}" }
      end
      unless data_type == '.FIT'
        Log.fatal { "Unknown file type #{@header.data_type}" }
      end
    end

    def dump
      puts <<"EOT"
Fit File Header
  Header Size: #{header_size}
  Protocol Version: #{protocol_version}
  Profile Version: #{profile_version}
  Data Size: #{data_size}
EOT
    end

    def end_pos
      header_size + data_size
    end

  end

end

