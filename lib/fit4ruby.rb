#!/usr/bin/env ruby -w
# encoding: UTF-8
#
# = fit4ruby.rb -- Fit4Ruby - FIT file processing library for Ruby
#
# Copyright (c) 2014 by Chris Schlaeger <cs@taskjuggler.org>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of version 2 of the GNU General Public License as
# published by the Free Software Foundation.
#

require 'fit4ruby/FitFile'

module Fit4Ruby

  def self.read(file, dump = false)
    FitFile.new.read(file, dump)
  end

  def self.write(file, activity)
    FitFile.new.write(file, activity)
  end

end

