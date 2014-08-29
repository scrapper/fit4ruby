#!/usr/bin/env ruby -w
# encoding: UTF-8
#
# = GlobalFitMessage.rb -- Fit4Ruby - FIT file processing library for Ruby
#
# Copyright (c) 2014 by Chris Schlaeger <cs@taskjuggler.org>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of version 2 of the GNU General Public License as
# published by the Free Software Foundation.
#

require 'fit4ruby/GlobalFitDictList'
require 'fit4ruby/Converters'
require 'fit4ruby/FitDefinitionField'

module Fit4Ruby

  class GlobalFitMessage

    attr_reader :name, :number, :fields

    class Field

      include Converters

      attr_reader :type, :name, :opts

      def initialize(type, name, opts = {})
        @type = type
        @name = name
        @opts = opts
      end

      def to_machine(value)
        return nil if value.nil?

        if @opts.include?(:dict) &&
           (dict = GlobalFitDictionaries[@opts[:dict]])
          return dict.name(value) || "Undocumented value #{value}"
        end

        case @opts[:type]
        when 'coordinate'
          value *= 180.0 / 2147483648
        when 'date_time'
          value = fit_time_to_time(value)
        end
        value /= @opts[:scale].to_f if @opts[:scale]
        value -= @opts[:offset] if @opts[:offset]
        value
      end

      def to_human(value)
        return nil if value.nil?

        if @opts.include?(:dict) &&
           (dict = GlobalFitDictionaries[@opts[:dict]])
          return [ dict.name(value) || "Undocumented value #{value}", nil ]
        end

        value /= @opts[:scale].to_f if @opts[:scale]
        value -= @opts[:offset] if @opts[:offset]

        case @opts[:type]
        when 'coordinate'
          value *= 180.0 / 2147483648
        when 'date_time'
          value = fit_time_to_time(value).strftime("%Y-%m-%d %H:%M:%S")
        when 'duration'
          value = secsToDHMS(value)
        end
        [ value, @opts[:unit] ]
      end

      def fit_to_native(value)
        return nil if value == FitDefinitionField.undefined_value(@type)

        if @opts.include?(:dict) && (dict = GlobalFitDictionaries[@opts[:dict]])
          return dict.name(value) || "Undocumented value #{value}"
        end

        value /= @opts[:scale].to_f if @opts[:scale]
        value -= @opts[:offset] if @opts[:offset]

        case @opts[:type]
        when 'coordinate'
          value *= 180.0 / 2147483648
        when 'date_time'
          value = fit_time_to_time(value)
        end

        value
      end

      def native_to_fit(value)
        return FitDefinitionField.undefined_value(@type) if value.nil?

        if @opts.include?(:dict) && (dict = GlobalFitDictionaries[@opts[:dict]])
          unless (dv = dict.value_by_name(value))
            Log.error "Unknown value '#{value}' assigned to field #{@name}"
            return FitDefinitionField.undefined_value(@type)
          else
            return dv
          end
        end

        value += @opts[:offset] if @opts[:offset]
        value = (value * @opts[:scale].to_f).to_i if @opts[:scale]

        case @opts[:type]
        when 'coordinate'
          value = (value * 2147483648.0 / 180.0).to_i
        when 'date_time'
          value = time_to_fit_time(value)
        end
        if value.is_a?(Float) && @opts[:scale].nil?
          Log.error "Field #{@name} must not be a Float value"
        end

        value
      end

      def to_s(value)
        return "[no value]" if value.nil?

        human_readable = to_human(value)
        "#{human_readable[0]}" +
          "#{ human_readable[1] ? " #{human_readable[1]}" : ''}"
      end

    end

    def initialize(name, number)
      @name = name
      @number = number
      @fields = {}
    end

    def field(number, type, name, opts = {})
      if @fields.include?(number)
        raise "Field #{number} has already been defined"
      end
      @fields[number] = Field.new(type, name, opts)
    end

    def find_by_name(field_name)
      @fields.values.find { |f| f.name == field_name }
    end

    def write(io, local_message_type)
      header = FitRecordHeader.new
      header.normal = 0
      header.message_type = 1
      header.local_message_type = local_message_type
      header.write(io)

      definition = FitDefinition.new
      definition.global_message_number = @number
      definition.setup(self)
      definition.write(io)
    end

  end

  class GlobalFitMessageList

    def initialize(&block)
      @current_message = nil
      @messages = {}
      instance_eval(&block) if block_given?
    end

    def message(number, name)
      if @messages.include?(number)
        raise "Message #{number} has already been defined"
      end
      @messages[number] = @current_message = GlobalFitMessage.new(name, number)
    end

    def each
      @messages.each_value do |message|
        yield(message)
      end
    end

    def write(io)
      # The FIT file supports more than 16 global message types. But only 16
      # can be declared as local message types at any point of time. If there
      # are more then 16 messages, the current subset must be declared before
      # it's being used in the data records of the file.
      # Since we currently have 16 or less message types, we just write them
      # all upfront before the data records.
      if @messages.length > 16
        raise 'Cannot support more than 16 message types!'
      end

      local_message_type = 0
      @messages.each do |number, message|
        message.write(io, local_message_type)
      end
    end

    def find_by_name(name)
      @messages.values.find { |m| m.name == name }
    end

    def field(number, type, name, opts = {})
      unless @current_message
        raise "You must define a message first"
      end
      @current_message.field(number, type, name, opts)
    end

    def [](number)
      @messages[number]
    end

  end

end

