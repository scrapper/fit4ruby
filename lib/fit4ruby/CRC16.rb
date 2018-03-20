#!/usr/bin/env ruby -w
# encoding: UTF-8
#
# = CRC16.rb -- Fit4Ruby - FIT file processing library for Ruby
#
# Copyright (c) 2014, 2015, 2016, 2017, 2018
#   by Chris Schlaeger <cs@taskjuggler.org>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of version 2 of the GNU General Public License as
# published by the Free Software Foundation.
#

module Fit4Ruby

  module CRC16

    def write_crc(io, start_pos, end_pos)
      # Compute the checksum over the data section of the file and append it
      # to the file. Ideally, we should compute the CRC from data in memory
      # instead of the file data.
      crc = compute_crc(io, start_pos, end_pos)
      io.seek(end_pos)
      BinData::Uint16le.new(crc).write(io)

      crc
    end

    def compute_crc(io, start_pos, end_pos)
      crc_table = [
        0x0000, 0xCC01, 0xD801, 0x1400, 0xF001, 0x3C00, 0x2800, 0xE401,
        0xA001, 0x6C00, 0x7800, 0xB401, 0x5000, 0x9C01, 0x8801, 0x4400
      ]

      io.seek(start_pos)

      crc = 0
      while io.pos < end_pos
        if io.eof?
          raise IOError, "Premature end of file"
        end

        byte = io.readbyte

        0.upto(1) do |i|
          tmp = crc_table[crc & 0xF]
          crc = (crc >> 4) & 0x0FFF
          crc = crc ^ tmp ^ crc_table[(byte >> (4 * i)) & 0xF]
        end
      end

      crc
    end

  end

end

