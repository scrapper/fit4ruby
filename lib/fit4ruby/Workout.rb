#!/usr/bin/env ruby -w
# encoding: UTF-8
#
# = Workout.rb -- Fit4Ruby - FIT file processing library for Ruby
#
# Copyright (c) 2021 by Chris Schlaeger <cs@taskjuggler.org>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of version 2 of the GNU General Public License as
# published by the Free Software Foundation.
#

require 'fit4ruby/FitDataRecord'

module Fit4Ruby

  class Workout < FitDataRecord

    def initialize(field_values = {})
      super('workout')
      set_field_values(field_values)
    end

    def check(index)
    end

  end

end


