#!/usr/bin/env ruby -w
# encoding: UTF-8
#
# = TrainingStatus.rb -- Fit4Ruby - FIT file processing library for Ruby
#
# Copyright (c) 2018 by Chris Schlaeger <cs@taskjuggler.org>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of version 2 of the GNU General Public License as
# published by the Free Software Foundation.
#

require 'fit4ruby/FitDataRecord'

module Fit4Ruby

  # This class corresponds to the training_status message.
  #
  # This is not part of the officially documented FIT API. Names may change in
  # the future if the real Garmin names get known.
  class TrainingStatus < FitDataRecord

    def initialize(field_values = {})
      super('training_status')
      set_field_values(field_values)
    end

    # Ensure that FitDataRecords have a deterministic sequence. Device infos
    # are sorted by device_index.
    def <=>(fdr)
      @timestamp == fdr.timestamp ?
        @message.name == fdr.message.name ?
          @device_index <=> fdr.device_index :
          RecordOrder.index(@message.name) <=>
            RecordOrder.index(fdr.message.name) :
        @timestamp <=> fdr.timestamp
    end

    def check(index)
    end

  end

end


