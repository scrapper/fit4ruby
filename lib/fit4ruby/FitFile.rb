#!/usr/bin/env ruby -w
# encoding: UTF-8
#
# = FitFile.rb -- Fit4Ruby - FIT file processing library for Ruby
#
# Copyright (c) 2014, 2015, 2016, 2017, 2018
#   by Chris Schlaeger <cs@taskjuggler.org>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of version 2 of the GNU General Public License as
# published by the Free Software Foundation.
#

require 'fit4ruby/Log'
require 'fit4ruby/CRC16'
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

    include CRC16

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

      entities = []
      begin
        while !io.eof?
          offset = io.pos

          header = FitHeader.read(io)

          # If the header has a CRC the header is not included in the
          # checksumed bytes. Otherwise it is included.
          check_crc(io, header.has_crc? ? header.header_size : 0,
                    offset + header.end_pos)

          # Rewind back to the beginning of the data right after the header.
          io.seek(header.header_size)

          entity = FitFileEntity.new
          # This Array holds the raw data of the records that may be needed to
          # dump a human readable form of the FIT file.
          records = []
          # This hash will hold a counter for each record type. The counter is
          # incremented each time the corresponding record type is found.
          record_counters = Hash.new { 0 }
          while io.pos < offset + header.end_pos
            record = FitRecord.new(definitions, entity)
            record.read(io, entity, filter, record_counters)
            records << record if filter
          end
          # Skip the 2 CRC bytes
          io.seek(2, :CUR)

          header.dump if filter && filter.record_numbers.nil?
          dump_records(records) if filter

          entity.check
          entities << entity
        end
      ensure
        io.close
      end

      entities[0].top_level_record
    end

    def write(file_name, top_level_record)
      begin
        io = ::File.open(file_name, 'wb+')
      rescue StandardError => e
        Log.fatal "Cannot open FIT file '#{file_name}': #{e.message}"
      end

      begin
        # Create a header object, but don't yet write it into the file.
        header = FitHeader.new
        start_pos = header.header_size

        # Move the pointer behind the header section.
        io.seek(start_pos)
        id_mapper = FitMessageIdMapper.new
        top_level_record.write(io, id_mapper)
        end_pos = io.pos

        crc = write_crc(io, start_pos, end_pos)

        # Complete the data of the header section and write it at the start of
        # the file.
        header.data_size = end_pos - start_pos
        io.seek(0)
        header.write(io)
      ensure
        io.close
      end
    end

    private

    def check_crc(io, start_pos, end_pos)
      crc = compute_crc(io, start_pos, end_pos)

      # Read the 2 CRC bytes from the end of the file
      io.seek(end_pos)
      crc_ref = io.readbyte.to_i | (io.readbyte.to_i << 8)

      unless crc == crc_ref
        Log.error "Checksum error of segment #{start_pos} to #{end_pos} " +
                  "in file '#{@file_name}'. " +
                  "Computed 0x#{"%04X" % crc} instead of 0x#{"%04X" % crc_ref}."
      end
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
