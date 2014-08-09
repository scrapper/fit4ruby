#!/usr/bin/env ruby -w
# encoding: UTF-8
#
# = UserProfile.rb -- Fit4Ruby - FIT file processing library for Ruby
#
# Copyright (c) 2014 by Chris Schlaeger <cs@taskjuggler.org>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of version 2 of the GNU General Public License as
# published by the Free Software Foundation.
#

require 'fit4ruby/FitDataRecord'

module Fit4Ruby

  class UserProfile < FitDataRecord

    def initialize(field_values = {})
      super('user_profile')
      set_field_values(field_values)
    end

  end

end

