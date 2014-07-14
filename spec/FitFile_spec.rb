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
    a.start_time = Time.parse('2014-07-14-21:00')
    a.duration = 30 * 60
    Fit4Ruby.write(fit_file, a)
    b = Fit4Ruby.read(fit_file)
    a.start_time.should == b.start_time
    a.duration.should == b.duration
    File.delete(fit_file)
  end

end

