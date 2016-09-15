#!/usr/bin/env ruby -w
# encoding: UTF-8
#
# = FitFile.rb -- Fit4Ruby - FIT file processing library for Ruby
#
# Copyright (c) 2014, 2015 by Chris Schlaeger <cs@taskjuggler.org>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of version 2 of the GNU General Public License as
# published by the Free Software Foundation.
#

require 'fit4ruby/Log'
require 'fit4ruby/FileNameCoder'
require 'fit4ruby/FitHeader'
require 'fit4ruby/FitFileEntity'
require 'fit4ruby/FitRecord'
require 'fit4ruby/FitFilter'
require 'fit4ruby/FitMessageIdMapper'
require 'fit4ruby/GlobalFitMessages'
require 'fit4ruby/GlobalFitDictionaries'

module Fit4Ruby

  class FitFile

    def initialize()
      @header = nil
    end

    def read(file_name, filter = nil)
      @file_name = file_name
      definitions = {}
      begin
        io = ::File.open(file_name, 'rb')
      rescue StandardError => e
        Log.fatal "Cannot open FIT file '#{file_name}': #{e.message}"
      end
      header = FitHeader.read(io)
      header.check
  
      has_header_crc = header.header_size == 14 && header.crc != 0
      if has_header_crc
        computed_head_crc = compute_crc(io, 0, 12)
        unless header.crc == computed_head_crc
          Log.fatal "Header checksum error in file '#{@file_name}'. " +
                    "Computed #{"%04X" % computed_head_crc} instead of #{"%04X" % header.crc}."
        end
      end
      
      io.seek(header.header_size, :SET) # set the file pointer to start of data for file 
      check_file_crc(io, has_header_crc, header.end_pos)

      entity = FitFileEntity.new
      # This Array holds the raw data of the records that may be needed to
      # dump a human readable form of the FIT file.
      records = []
      # This hash will hold a counter for each record type. The counter is
      # incremented each time the corresponding record type is found.
      record_counters = Hash.new { 0 }
      while io.pos < header.end_pos
        record = FitRecord.new(definitions)
        record.read(io, entity, filter, record_counters)
        records << record if filter
      end

      io.close

      header.dump if filter && filter.record_numbers.nil?
      dump_records(records) if filter

      entity.check
      entity.top_level_record
    end

    def write(file_name, top_level_record)
      begin
        io = ::File.open(file_name, 'wb+')
      rescue StandardError => e
        Log.fatal "Cannot open FIT file '#{file_name}': #{e.message}"
      end

      # Create a header object, but don't yet write it into the file.
      header = FitHeader.new
      start_pos = header.header_size
      # Move the pointer behind the header section.
      io.seek(start_pos)
      id_mapper = FitMessageIdMapper.new
      top_level_record.write(io, id_mapper)
      end_pos = io.pos

      write_crc(io, start_pos, end_pos)

      # Complete the data of the header section and write it at the start of
      # the file.
      header.data_size = end_pos - start_pos
      io.seek(0)
      # Write all of header to be able to calculate header crc and then write that
      header.write(io) 
      header.crc = compute_crc(io, 0, 12)
      io.seek(0)
      header.write(io)

      io.close
    end

    private

    def check_file_crc(io, has_header_crc, end_pos)
      # Save the current file IO position
      current_pos = io.pos

      start_pos = has_header_crc ? current_pos : 0
      crc = compute_crc(io, start_pos, end_pos)

      # Read the 2 CRC bytes from the end of the file
      io.seek(-2, IO::SEEK_END)
      crc_ref = io.readbyte.to_i | (io.readbyte.to_i << 8)
      io.seek(current_pos)

      unless crc == crc_ref
        Log.fatal "Checksum error in file '#{@file_name}'. " +
                  "Computed #{"%04X" % crc} instead of #{"%04X" % crc_ref}."
      end
    end

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
        byte = io.readbyte

        0.upto(1) do |i|
          tmp = crc_table[crc & 0xF]
          crc = (crc >> 4) & 0x0FFF
          crc = crc ^ tmp ^ crc_table[(byte >> (4 * i)) & 0xF]
        end
      end

      crc
    end

    def dump_records(records)
      # For each message number we keep a count for how often we already had
      # this kind of message.
      message_counters = Hash.new(0)

      records.each do |record|
        record.dump(message_counters[record.number])
        # Increase the counter for this message number.
        message_counters[record.number] += 1
      end
    end

  end

end
