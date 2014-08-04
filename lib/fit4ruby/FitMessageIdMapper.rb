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

  class FitMessageIdMapper

    class Entry < Struct.new(:global_id, :last_use)
    end

    def initialize
      @entries = Array.new(16, nil)
    end

    def add_global(id)
      unless (slot = @entries.index { |e| e.nil? })
        # No more free slots. We have to find the least recently used one.
        slot = 0
        0.upto(15) do |i|
          if i != slot && @entries[slot].last_use > @entries[i].last_use
            slot = i
          end
        end
      end
      @entries[slot] = Entry.new(id, Time.now)

      slot
    end

    def get_local(id)
      0.upto(15) do |i|
        if (entry = @entries[i]) && entry.global_id == id
          entry.last_use = Time.now
          return i
        end
      end
      nil
    end

  end

end

