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

  # The GlobalFitMessage stores an abstract description of a particular
  # FitMessage. It holds information like the name, the global ID number and
  # the data fields of the message.
  class GlobalFitMessage

    attr_reader :name, :number, :fields_by_name, :fields_by_number

    # The Field objects describe the name, type and optional attributes of a
    # FitMessage definition field. It also provides methods to convert field
    # values into various formats.
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
        when 'activity_intensity'
          # Activity monitoring data contains a byte value that consists of 5
          # bit for the activity type and 3 bit for the intensity. Activty 0x8
          # is resting. Instead if value + unit we return activity type +
          # intensity here.
          return [ value & 0x1F, (value >> 5) & 0x7 ]
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

    # A GlobalFitMessage may have Field entries that are dependent on the
    # value of another Field. These alternative fields all depend on the value
    # of a specific other Field of the GlobalFitMessage and their presense is
    # mutually exclusive. An AltField object models such a group of Field
    # objects.
    class AltField

      attr_reader :fields, :ref_field

      # Create a new AltField object.
      # @param message [GlobalFitMessage] reference to the GlobalFitMessage
      #        this field belongs to.
      # @param ref_field [String] The name of the field that is used to select
      #        the alternative.
      def initialize(message, ref_field, &block)
        @message = message
        @ref_field = ref_field
        @fields = {}

        instance_eval(&block) if block_given?
      end

      def field(ref_value, type, name, opts = {})
        field = Field.new(type, name, opts)
        if ref_value.respond_to?('each')
          ref_value.each do |rv|
            @fields[rv] = field
          end
        else
          @fields[ref_value] = field
        end
        @message.register_field_by_name(field, name)
      end

      # Select the alternative field based on the actual field values of the
      # FitMessageRecord.
      def select(field_values_by_name)
        unless (value = field_values_by_name[@ref_field])
          Log.fatal "The selection field #{@ref_field} for the alternative " +
                    "field is undefined in global message #{@message.name}: " +
                    field_values_by_name.inspect
        end
        @fields.each do |ref_value, field|
          return field if ref_value == value
        end
        return @fields[:default] if @fields[:default]

        Log.fatal "The selector value #{value} for the alternative field " +
                  "is not supported in global message #{@message.name}."
      end

    end

    # Create a new GlobalFitMessage definition.
    # @param name [String] name of the FIT message
    # @param number [Fixnum] global message number
    def initialize(name, number)
      @name = name
      @number = number
      # Field names must be unique. A name always matches a single Field.
      @fields_by_name = {}
      # Field numbers are not unique. A group of alternative fields shares the
      # same number and is stored as an AltField. Otherwise as Field.
      @fields_by_number = {}
    end

    # Two GlobalFitMessage objects are considered equal if they have the same
    # number, name and list of named fields.
    def ==(m)
      @number == m.number && @name == m.name &&
        @fields_by_name.keys.sort == m.fields_by_name.keys.sort
    end

    # Define a new Field for this message definition.
    def field(number, type, name, opts = {})
      field = Field.new(type, name, opts)
      register_field_by_name(field, name)
      register_field_by_number(field, number)
    end

    # Define a new set of Field alternatives for this message definition.
    def alt_field(number, ref_field, &block)
      unless @fields_by_name.include?(ref_field)
        raise "Unknown ref_field: #{ref_field}"
      end

      field = AltField.new(self, ref_field, &block)
      register_field_by_number(field, number)
    end

    def register_field_by_name(field, name)
      if @fields_by_name.include?(name)
        raise "Field '#{name}' has already been defined"
      end

      @fields_by_name[name] = field
    end

    def register_field_by_number(field, number)
      if @fields_by_name.include?(number)
        raise "Field #{number} has already been defined"
      end

      @fields_by_number[number] = field
    end

    def construct(field_values_by_name)
      gfm = GlobalFitMessage.new(@name, @number)

      @fields_by_number.each do |number, field|
        if field.is_a?(AltField)
          # For alternative fields, we need to look at the value of the
          # selector field and pick the corresponding Field.
          field = field.select(field_values_by_name)
        end
        gfm.field(number, field.type, field.name, field.opts)
      end

      gfm
    end

    def write(io, local_message_type, global_fit_message = self)
      header = FitRecordHeader.new
      header.normal = 0
      header.message_type = 1
      header.local_message_type = local_message_type
      header.write(io)

      definition = FitDefinition.new
      definition.global_message_number = @number
      definition.setup(global_fit_message)
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

    def alt_field(number, ref_field, &block)
      unless @current_message
        raise "You must define a message first"
      end
      @current_message.alt_field(number, ref_field, &block)
    end

    def [](number)
      @messages[number]
    end

  end

end

