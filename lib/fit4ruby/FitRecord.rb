#!/usr/bin/env ruby -w
# encoding: UTF-8
#
# = FitRecord.rb -- Fit4Ruby - FIT file processing library for Ruby
#
# Copyright (c) 2014, 2015 by Chris Schlaeger <cs@taskjuggler.org>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of version 2 of the GNU General Public License as
# published by the Free Software Foundation.
#

require 'fit4ruby/Log'
require 'fit4ruby/FitRecordHeader'
require 'fit4ruby/FitDefinition'
require 'fit4ruby/FitMessageRecord'
require 'fit4ruby/FitFilter'
require 'fit4ruby/FitFileEntity'

module Fit4Ruby

  # The FitRecord is a basic building block of a FIT file. It can either
  # contain a definition of a message record or an actual message record with
  # FIT data. A FIT record always starts with a header that describes what
  # kind of record this is.
  class FitRecord

    def initialize(definitions)
      @definitions = definitions
      @name = @number = @fields = nil
    end

    def read(io, entity, filter, record_counters)
      header = FitRecordHeader.read(io)

      if !header.compressed?
        # process normal headers
        local_message_type = header.local_message_type.snapshot
        if header.message_type.snapshot == 1
          # process definition message
          definition = FitDefinition.read(io)
          @definitions[local_message_type] = FitMessageRecord.new(definition)
        else
          # process data message
          definition = @definitions[local_message_type]
          unless definition
            Log.fatal "Undefined local message type: #{local_message_type}"
          end
          if filter
            @number = @definitions[local_message_type].global_message_number
            index = (record_counters[@number] += 1)

            # Check if we have a filter defined to collect raw dumps of the
            # data in the message records. The dump is collected in @fields
            # for later output.
            if (filter.record_numbers.nil? ||
                filter.record_numbers.include?(@number)) &&
               (filter.record_indexes.nil? ||
                filter.record_indexes.include?(index))
              @name = definition.name
              @fields = []
            end
          end
          definition.read(io, entity, filter, @fields)
        end
      else
        # process compressed timestamp header
        time_offset = header.time_offset
        Log.fatal "Support for compressed headers not yet implemented"
      end

      self
    end

    def dump
      return unless @fields

      begin
        puts "Message #{@number}: #{@name}" unless @fields.empty?
        @fields.each do |type, name, value|
          puts " [#{"%-7s" % type}] #{name}: " + "#{value}"
        end
      rescue Errno::EPIPE
        # Avoid ugly error message when aborting a less/more pipe.
      end
    end

  end

end

