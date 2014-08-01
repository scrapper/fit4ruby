#!/usr/bin/env ruby -w
# encoding: UTF-8
#
# = FileCreator.rb -- Fit4Ruby - FIT file processing library for Ruby
#
# Copyright (c) 2014 by Chris Schlaeger <cs@taskjuggler.org>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of version 2 of the GNU General Public License as
# published by the Free Software Foundation.
#

require 'fit4ruby/version'
require 'fit4ruby/FitDataRecord'

module Fit4Ruby

  class FileCreator < FitDataRecord

    def initialize
      super('file_creator')
      @software_version = VERSION.split('.').join('').to_i
    end

  end

end

