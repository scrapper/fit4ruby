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

  before(:each) do
    a = Fit4Ruby::Activity.new
    a.total_timer_time = 30 * 60.0
    a.new_user_profile({ :age => 33, :height => 1.78, :weight => 73.0,
                         :gender => 'male', :activity_class => 4.0,
                         :max_hr => 178 })

    a.new_event({ :event => 'timer', :event_type => 'start_time' })
    a.new_device_info({ :device_index => 0 })
    a.new_device_info({ :device_index => 1, :battery_status => 'ok' })
    ts = Time.now
    0.upto(a.total_timer_time / 60) do |mins|
      ts += 60
      a.new_record({
        :timestamp => ts,
        :position_lat => 51.5512 - mins * 0.0008,
        :position_long => 11.647 + mins * 0.002,
        :distance => 200.0 * mins,
        :altitude => (100 + mins * 0.5).to_i,
        :speed => 3.1,
        :vertical_oscillation => 9 + mins * 0.02,
        :stance_time => 235.0 * mins * 0.01,
        :stance_time_percent => 32.0,
        :heart_rate => 140 + mins,
        :cadence => 75,
        :activity_type => 'running',
        :fractional_cadence => (mins % 2) / 2.0
      })

      if mins > 0 && mins % 5 == 0
        a.new_lap({ :timestamp => ts, :sport => 'running',
                    :total_cycles => 195 })
      end
    end
    a.new_session({ :timestamp => ts, :sport => 'running' })
    a.new_event({ :timestamp => ts, :event => 'recovery_time',
                  :event_type => 'marker',
                  :recovery_time => 2160 })
    a.new_event({ :timestamp => ts, :event => 'vo2max',
                  :event_type => 'marker', :vo2max => 52 })
    a.new_event({ :timestamp => ts, :event => 'timer',
                  :event_type => 'stop_all' })
    a.new_device_info({ :timestamp => ts, :device_index => 0 })
    ts += 1
    a.new_device_info({ :timestamp => ts, :device_index => 1,
                        :battery_status => 'low' })
    ts += 120
    a.new_event({ :timestamp => ts, :event => 'recovery_hr',
                  :event_type => 'marker', :recovery_hr => 132 })

    a.aggregate

    @activity = a
  end

  it 'should write a simple FIT file and read it back' do
    fit_file = 'test.fit'

    File.delete(fit_file) if File.exists?(fit_file)
    Fit4Ruby.write(fit_file, @activity)
    File.exists?(fit_file).should be_true
    puts File.absolute_path(fit_file)

    b = Fit4Ruby.read(fit_file)
    b.should == @activity
    File.delete(fit_file)
  end

end

