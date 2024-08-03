#!/usr/bin/env ruby -w
# encoding: UTF-8
#
# = HeartRateZones.rb -- Fit4Ruby - FIT file processing library for Ruby
#
# Copyright (c) 2017 by Chris Schlaeger <cs@taskjuggler.org>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of version 2 of the GNU General Public License as
# published by the Free Software Foundation.
#

require 'fit4ruby/FitDataRecord'
require 'fit4ruby/RecordAggregator'

module Fit4Ruby

  class HeartRateZones < FitDataRecord

    include RecordAggregator

    def initialize(field_values)
      super('heart_rate_zones')

      set_field_values(field_values)
    end

    def check(index)
      unless @lap_index == index
        Log.warn "lap_index must be #{index}, not #{@lap_index}"
      end
    end

  end

end
