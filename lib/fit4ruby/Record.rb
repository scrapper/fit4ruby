#!/usr/bin/env ruby -w
# encoding: UTF-8
#
# = Record.rb -- Fit4Ruby - FIT file processing library for Ruby
#
# Copyright (c) 2014 by Chris Schlaeger <cs@taskjuggler.org>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of version 2 of the GNU General Public License as
# published by the Free Software Foundation.
#

require 'fit4ruby/FitDataRecord'

module Fit4Ruby

  # The Record corresponds to the record FIT message. A Record is a basic set
  # of primary measurements that are associated with a certain timestamp.
  class Record < FitDataRecord

    # Create a new Record object.
    # @param field_values [Hash] Hash that provides initial values for certain
    #        fields.
    def initialize(field_values = {})
      super('record')
      set_field_values(field_values)
    end

    # Convert the 'speed' field into a running pace. The pace is measured in
    # minutes per Kilometer.
    def pace
      1000.0 / (@speed * 60.0)
    end

  end

end

