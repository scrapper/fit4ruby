#!/usr/bin/env ruby -w
# encoding: UTF-8
#
# = Session.rb -- Fit4Ruby - FIT file processing library for Ruby
#
# Copyright (c) 2014 by Chris Schlaeger <cs@taskjuggler.org>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of version 2 of the GNU General Public License as
# published by the Free Software Foundation.
#

require 'fit4ruby/Converters'
require 'fit4ruby/FitDataRecord'

module Fit4Ruby

  class Session < FitDataRecord

    include Converters

    def initialize
      super('session')
      @laps = []
    end

    def check(activity)
      @first_lap_index.upto(@first_lap_index - @num_laps) do |i|
        if (lap = activity.lap[i])
          @laps << lap
        else
          Log.error "Session references lap #{i} which is not contained in "
                    "the FIT file."
        end
      end
    end

    def avg_stride_length
      return nil unless @total_strides

      @total_distance / @total_strides
    end

  end

end

