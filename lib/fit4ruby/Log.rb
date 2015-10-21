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

require 'monitor'
require 'logger'
require 'singleton'

module Fit4Ruby

  # This is the Exception type that will be thrown for all unrecoverable
  # errors.
  class Error < StandardError ; end

  # The ILogger class is a singleton that provides a common logging mechanism
  # to all objects. It exposes essentially the same interface as the Logger
  # class, just as a singleton and with some additional methods like 'fatal'
  # and 'cricital'.
  class ILogger < Monitor

    include Singleton

    @@logger = Logger.new(STDOUT)

    # Pass all calls to unknown methods to the @@logger object.
    def method_missing(method, *args, &block)
      @@logger.send(method, args, &block)
    end

    # Make it properly introspectable.
    def respond_to?(method, include_private = false)
      @@logger.respond_to?(method)
    end

    # Print an error message via the Logger and exit the program with exit
    # code 1.
    def fatal(msg)
      @@logger.error(msg)
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

  Log = ILogger.instance
  Log.level = Logger::WARN
  Log.formatter = proc do |severity, time, progname, msg|
    msg + "\n"
  end

end

