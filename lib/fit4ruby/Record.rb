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

module Fit4Ruby

  class Record

    attr_reader :timestamp, :latitude, :longitude, :altitude, :distance,
                :speed, :vertical_oscillation, :cadence, :stance_time

    def initialize
    end

    def set(field, value)
      case field
      when 'timestamp'
        @timestamp = value
      when 'position_lat'
        @latitude = value
      when 'position_long'
        @longitude = value
      when 'altitude'
        @altitude = value
      when 'distance'
        @distance = value
      when 'speed'
        @speed = value
      when 'vertical_oscillation'
        @vertical_oscillation = value
      when 'cadence'
        @cadence = 2 * value
      when 'fractional_cadence'
        @cadence += 2 * value if @cadence
      when 'stance_time'
        @stance_time = value
      else
      end
    end

    def pace
      1000.0 / (@speed * 60.0)
    end

  end

end

