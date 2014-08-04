#!/usr/bin/env ruby -w
# encoding: UTF-8
#
# = FitFile_spec.rb -- Fit4Ruby - FIT file processing library for Ruby
#
# Copyright (c) 2014 by Chris Schlaeger <cs@taskjuggler.org>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of version 2 of the GNU General Public License as
# published by the Free Software Foundation.
#

require 'fit4ruby'

describe Fit4Ruby do

  it 'should write a simple .fit file' do
    fit_file = 'test.fit'

    a = Fit4Ruby::Activity.new
    a.timestamp = Time.parse('2014-07-14-21:00')
    a.total_timer_time = 30 * 60
    up = a.new_record('user_profile')
    up.age = 33
    up.height = 1.78
    up.weight = 73.0
    up.gender = 'male'
    up.activity_class = 4.0
    up.max_hr = 178
    0.upto(30) do |mins|
      r = a.new_record('record')
      r.timestamp = a.timestamp + mins * 60
      r.distance = 200.0 * mins
      r.cadence = 75

      if mins > 0 && mins % 5 == 0
        s = a.new_record('lap')
      end
    end
    a.new_record('session')
    Fit4Ruby.write(fit_file, a)
    b = Fit4Ruby.read(fit_file)
    b.should == a
    File.delete(fit_file)
  end

end

