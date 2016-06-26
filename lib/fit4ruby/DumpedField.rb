#!/usr/bin/env ruby -w
# encoding: UTF-8
#
# = DumpedField.rb -- Fit4Ruby - FIT file processing library for Ruby
#
# Copyright (c) 2016 by Chris Schlaeger <cs@taskjuggler.org>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of version 2 of the GNU General Public License as
# published by the Free Software Foundation.
#

module Fit4Ruby

  # If the user has requested a dump of the records, this class is used to
  # capture a subset of the field related information for the later textual
  # dump.
  class DumpedField

    attr_reader :message_number, :field_number

    # Create a new field dump record.
    # @param message_number [Fixnum] The global message number of the message
    #        this field belongs to.
    # @param field_number [Fixnum] The number of the FIT message field
    # @param name [String] The name of the field
    # @param type [Symbol] The type of the field
    # @param value [String] A human readable dump of the field value
    def initialize(message_number, field_number, name, type, value)
      @message_number = message_number
      @field_number = field_number
      @name = name
      @type = type
      @value = value
    end

    def <=>(f)
      @field_number <=> f.field_number
    end

    def to_s(index)
      "[#{'%03d' % @message_number}:#{'%03d' % index}:" +
      "#{'%03d' % @field_number}:" +
      "#{"%-7s" % @type}] #{@name}: " + "#{@value}"
    end

  end

end

