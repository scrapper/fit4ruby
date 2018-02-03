#!/usr/bin/env ruby -w
# encoding: UTF-8
#
# = FieldDescription.rb -- Fit4Ruby - FIT file processing library for Ruby
#
# Copyright (c) 2017 by Chris Schlaeger <cs@taskjuggler.org>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of version 2 of the GNU General Public License as
# published by the Free Software Foundation.
#

require 'fit4ruby/FitDataRecord'

module Fit4Ruby

  # This class corresponds to the FieldDescription FIT message.
  class FieldDescription < FitDataRecord

    # Create a new FieldDescription object.
    # @param field_values [Hash] Hash that provides initial values for certain
    #        fields.
    def initialize(field_values = {})
      super('field_description')
      set_field_values(field_values)
    end

    def create_global_definition
      #gfm = GlobalFitMessages[native_message_num.snapshot]
    end

  end

end


