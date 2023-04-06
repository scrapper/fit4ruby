#!/usr/bin/env ruby -w
# encoding: UTF-8
#
# = Converters.rb -- Fit4Ruby - FIT file processing library for Ruby
#
# Copyright (c) 2014 by Chris Schlaeger <cs@taskjuggler.org>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of version 2 of the GNU General Public License as
# published by the Free Software Foundation.
#

module Fit4Ruby

  module Converters

    def conversion_factor(from_unit, to_unit)
      factors = {
        'm' => { 'km' => 0.001, 'in' => 39.3701, 'ft' => 3.28084,
                 'mi' => 0.000621371 },
        'mm' => { 'cm' => 0.1, 'in' => 0.0393701 },
        'm/s' => { 'km/h' => 3.6, 'mph' => 2.23694 },
        'min/km' => { 'min/mi' => 1.60934 },
        'kg' => { 'lbs' => 0.453592 }
      }
      return 1.0 if from_unit == to_unit
      unless factors.include?(from_unit)
        Log.fatal "No conversion factors defined for unit " +
                  "'#{from_unit}' to '#{to_unit}'"
      end

      factor = factors[from_unit][to_unit]
      if factor.nil?
        Log.fatal "No conversion factor from '#{from_unit}' to '#{to_unit}' " +
                  "defined."
      end
      factor
    end

    def convert_value(from_value, from_unit, to_unit)
      if from_unit == 'C' and to_unit == 'F'
        return (from_value * 9 / 5) + 32
      end

      return from_value * conversion_factor(from_unit, to_unit)
    end

    def speedToPace(speed, distance = 1000.0)
      if speed && speed > 0.01
        # We only show 2 fractional digits, so make sure we round accordingly
        # before we crack it up.
        pace = (distance.to_f / (speed * 60.0)).round(2)
        int, dec = pace.divmod 1
        "#{int}:#{'%02d' % (dec * 60)}"
      else
        "-:--"
      end
    end

    def secsToHM(secs)
      secs = secs.to_i
      s = secs % 60
      mins = secs / 60
      m = mins % 60
      h = mins / 60
      "#{h}:#{'%02d' % m}"
    end

    def secsToHMS(secs)
      secs = secs.to_i
      s = secs % 60
      mins = secs / 60
      m = mins % 60
      h = mins / 60
      "#{h}:#{'%02d' % m}:#{'%02d' % s}"
    end

    def secsToDHMS(secs)
      secs = secs.to_i
      s = secs % 60
      mins = secs / 60
      m = mins % 60
      hours = mins / 60
      h = hours % 24
      d = hours / 24
      "#{d} days #{h}:#{'%02d' % m}:#{'%02d' % s}"
    end

    def time_to_fit_time(t)
      (t - Time.parse('1989-12-31T00:00:00+00:00')).to_i
    end

    def fit_time_to_time(ft)
      Time.parse('1989-12-31T00:00:00+00:00') + ft.to_i
    end

  end

end

