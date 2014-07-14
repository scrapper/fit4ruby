#!/usr/bin/env ruby -w
# encoding: UTF-8
#
# = Log.rb -- Fit4Ruby - FIT file processing library for Ruby
#
# Copyright (c) 2014 by Chris Schlaeger <cs@taskjuggler.org>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of version 2 of the GNU General Public License as
# published by the Free Software Foundation.
#

require 'logger'

module Fit4Ruby

  # This is the Exception type that will be thrown for all unrecoverable
  # errors.
  class Error < StandardError ; end

  class ILogger < Logger

    def fatal(msg)
      super
      exit 1
    end

    def critical(msg, exception = nil)
      if exception
        raise Error, "#{msg}: #{exception.message}", exception.backtrace
      else
        raise Error, msg
      end
    end

  end

  Log = ILogger.new(STDOUT)
  Log.level = Logger::WARN
  Log.formatter = proc do |severity, time, progname, msg|
    msg + "\n"
  end

end

