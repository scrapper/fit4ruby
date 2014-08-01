#!/usr/bin/env ruby -w
# encoding: UTF-8
#
# = FitMessageRecord.rb -- Fit4Ruby - FIT file processing library for Ruby
#
# Copyright (c) 2014 by Chris Schlaeger <cs@taskjuggler.org>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of version 2 of the GNU General Public License as
# published by the Free Software Foundation.
#

require 'bindata'
require 'fit4ruby/Log'
require 'fit4ruby/GlobalFitMessage'

module Fit4Ruby

  class FitMessageRecord

    attr_reader :global_message_number, :name, :message_record

    def initialize(definition)
      @definition = definition
      @global_message_number = definition.global_message_number.snapshot

      if (@gfm = GlobalFitMessages[@global_message_number])
        @name = @gfm.name
      else
        @name = "message#{@global_message_number}"
        Log.warn { "Unknown global message number #{@global_message_number}" }
      end
      @message_record = produce(definition)
    end

    def read(io, activity, filter = nil, fields_dump = nil)
      @message_record.read(io)

      obj = case @name
            when 'activity'
              activity
            when 'device_info'
              activity.new_device_info
            when 'event'
              activity.new_event
            when 'file_creator'
              activity.new_file_creator
            when 'session'
              activity.new_session
            when 'lap'
              activity.new_lap
            when 'record'
              activity.new_record
            when 'user_profile'
              activity.new_user_profile
            when 'personal_record'
              activity.new_personal_record
            else
              nil
            end

      @definition.fields.each do |field|
        value = @message_record[field.name].snapshot
        obj.set(field.name, field.to_machine(value)) if obj
        if filter && fields_dump &&
           (filter.field_names.nil? ||
            filter.field_names.include?(field.name)) &&
           (value != field.undefined_value || !filter.ignore_undef)
          fields_dump[field] = value
        end
      end
    end

    private

    def produce(definition)
      fields = []
      definition.fields.each do |field|
        fields << [ field.type, field.name ]
      end

      BinData::Struct.new(:endian => definition.endian, :fields => fields)
    end


  end

end

