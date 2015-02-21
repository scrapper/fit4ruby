#!/usr/bin/env ruby -w
# encoding: UTF-8
#
# = FitMessageIdMapper.rb -- Fit4Ruby - FIT file processing library for Ruby
#
# Copyright (c) 2014 by Chris Schlaeger <cs@taskjuggler.org>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of version 2 of the GNU General Public License as
# published by the Free Software Foundation.
#

module Fit4Ruby

  # The FIT file maps GlobalFitMessage numbers to local numbers. Due to
  # restrictions in the format, only 16 local messages can be active at any
  # point in the file. If a GlobalFitMessage is needed that is currently not
  # mapped, a new entry is generated and the least recently used message is
  # evicted. The FitMessageIdMapper is the objects that stores those 16 active
  # entries and can map global to local message numbers.
  class FitMessageIdMapper

    # The entry in the mapper.
    class Entry < Struct.new(:global_message, :last_use)
    end

    def initialize
      @entries = Array.new(16, nil)
    end

    # Add a new GlobalFitMessage to the mapper and return the local message
    # number.
    def add_global(message)
      unless (slot = @entries.index { |e| e.nil? })
        # No more free slots. We have to find the least recently used one.
        slot = 0
        0.upto(15) do |i|
          if i != slot && @entries[slot].last_use > @entries[i].last_use
            slot = i
          end
        end
      end
      @entries[slot] = Entry.new(message, Time.now)

      slot
    end

    # Get the local message number for a given GlobalFitMessage. If there is
    # no message number, nil is returned.
    def get_local(message)
      0.upto(15) do |i|
        if (entry = @entries[i]) && entry.global_message == message
          entry.last_use = Time.now
          return i
        end
      end
      nil
    end

  end

end

