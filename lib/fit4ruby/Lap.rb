#!/usr/bin/env ruby -w
# encoding: UTF-8
#
# = Lap.rb -- Fit4Ruby - FIT file processing library for Ruby
#
# Copyright (c) 2014 by Chris Schlaeger <cs@taskjuggler.org>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of version 2 of the GNU General Public License as
# published by the Free Software Foundation.
#

module Fit4Ruby

  class Lap

    def set(field, value)
      case field
      when 'start_time'
        @start_time = value
      when 'total_timer_time'
        @duration = value
      when 'avg_speed'
        @avg_speed = value
      when 'avg_heart_rate'
        @avg_heart_rate = value
      when 'max_heart_rate'
        @max_heart_rate = value
      when 'avg_vertical_oscillation'
        @avg_vertical_oscillation = value
      when 'avg_stance_time'
        @avg_stance_time = value
      when 'avg_running_cadence'
        @avg_running_cadence = 2 * value
      when 'avg_fraction_cadence'
        @avg_running_cadence += 2 * value
      else
      end
    end

  end

end

