#!/usr/bin/env ruby -w
# encoding: UTF-8
#
# = Log.rb -- Fit4Ruby - FIT file processing library for Ruby
#
# Copyright (c) 2015 by Chris Schlaeger <cs@taskjuggler.org>
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

  # This is the Exception type that will be thrown for all program errors that
  # are caused by user error rather than program logic errors.
  class Abort < StandardError ; end

  # The ILogger class is a singleton that provides a common logging mechanism
  # to all objects. It exposes essentially the same interface as the Logger
  # class, just as a singleton and with some additional methods like 'fatal'
  # and 'cricital'.
  class ILogger < Monitor

    include Singleton

    @@logger = Logger.new(STDOUT)

    # Redirect all log messages to the given IO.
    # @param io [IO] Output file descriptor
    def open(io)
      begin
        @@logger = Logger.new(io)
      rescue => e
        @@logger = Logger.new(STDERR)
        Log.fatal "Cannot open log file: #{e.message}"
      end
    end

    # Pass all calls to unknown methods to the @@logger object.
    def method_missing(method, *args, &block)
      @@logger.send(method, *args, &block)
    end

    # Make it properly introspectable.
    def respond_to?(method, include_private = false)
      @@logger.respond_to?(method)
    end

    # Print an error message via the Logger and raise a Fit4Ruby::Abort.
    # This method should be used to abort the program in case of user errors.
    def abort(msg, &block)
      @@logger.error(msg, &block)
      raise Abort, msg
    end

    # Print an error message via the Logger and raise a Fit4Ruby::Error.
    # This method should be used to abort the program in case of program logic
    # errors.
    def fatal(msg, &block)
      @@logger.error(msg, &block)
      raise Error, msg
    end

  end

  Log = ILogger.instance
  Log.level = Logger::WARN
  Log.formatter = proc do |severity, time, progname, msg|
    msg + "\n"
  end

end

