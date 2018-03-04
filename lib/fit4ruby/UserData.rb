#!/usr/bin/env ruby -w
# encoding: UTF-8
#
# = UserData.rb -- Fit4Ruby - FIT file processing library for Ruby
#
# Copyright (c) 2018 by Chris Schlaeger <cs@taskjuggler.org>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of version 2 of the GNU General Public License as
# published by the Free Software Foundation.
#

require 'fit4ruby/FitDataRecord'

module Fit4Ruby

  # This class corresponds to the old_user_profile FIT message.
  class UserData < FitDataRecord

    # Create a new UserData object.
    # @param field_values [Hash] Hash that provides initial values for certain
    #        fields.
    def initialize(field_values = {})
      super('user_data')
      set_field_values(field_values)
    end

  end

end


