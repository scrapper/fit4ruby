#!/usr/bin/env ruby -w
# encoding: UTF-8
#
# = FitMessageRecord.rb -- Fit4Ruby - FIT file processing library for Ruby
#
# Copyright (c) 2015, 2016, 2017, 2018 by Chris Schlaeger <cs@taskjuggler.org>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of version 2 of the GNU General Public License as
# published by the Free Software Foundation.
#

require 'fit4ruby/Activity'
require 'fit4ruby/Monitoring_B'
require 'fit4ruby/GlobalFitMessage'
require 'fit4ruby/Metrics'

module Fit4Ruby

  # The FIT file is a generic container for all kinds of data. This could be
  # activity data, config files, workout definitions, etc. All data is stored
  # in FIT message records. Also the information what kind of FIT file this is
  # is stored in such a record. When we start reading the file, we actually
  # don't know what kind of file it is until we find the right record to tell
  # us. Since we already need to have gathered some information at this point,
  # we use this utility class to store the read data until we know what Ruby
  # objec we need to use to store it for later consumption.
  class FitFileEntity

    attr_reader :top_level_record, :developer_fit_messages

    # Create a FitFileEntity.
    def initialize
      @top_level_record = nil
      @developer_fit_messages = GlobalFitMessageList.new
    end

    # Set what kind of FIT file we are dealing with.
    # @return The Ruby object that will hold the content of the FIT file. It's
    # a derivative of FitDataRecord.
    def set_type(type)
      if @top_level_record
        Log.fatal "FIT file type has already been set to " +
                  "#{@top_level_record.class}"
      end
      case type
      when 4, 'activity'
        @top_level_record = Activity.new
        @type = 'activity'
      when 32, 'monitoring_b'
        @top_level_record = Monitoring_B.new
        @type = 'monitoring_b'
      when 44, 'metrics'
        @top_level_record = Metrics.new
        @type = 'metrics'
      else
        Log.error "Unsupported FIT file type #{type}"
        return nil
      end

      @top_level_record
    end

    # Add a new data record to the top-level object.
    def new_fit_data_record(type)
      return nil unless @top_level_record

      # We already have a record for the top-level type. Just return it.
      return @top_level_record if type == @type

      # For all other types, we need to create a new record inside the
      # top-level record.
      @top_level_record.new_fit_data_record(type)
    end

    # Check the consistency of the top-level object.
    def check
      return false unless @top_level_record
      @top_level_record.check
    end

    # Write the top-level object into a IO stream.
    def write(io, id_mapper)
      return unless @top_level_record
      @top_level_record.write(io, id_mapper)
    end

  end

end
