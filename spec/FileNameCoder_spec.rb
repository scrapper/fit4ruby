#!/usr/bin/env ruby -w
# encoding: UTF-8
#
# = FileNameCoder_spec.rb -- Fit4Ruby - FIT file processing library for Ruby
#
# Copyright (c) 2015 by Chris Schlaeger <cs@taskjuggler.org>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of version 2 of the GNU General Public License as
# published by the Free Software Foundation.
#

require 'fit4ruby/FileNameCoder'

describe Fit4Ruby::FileNameCoder do

  before(:all) do
    @data = [
      [ '2015-10-23T21:18:00+0200', '5ANJ1800.FIT' ],
      [ '2015-10-11T15:06:59+0000', '5ABF0659.FIT' ],
      [ '2014-04-19T07:31:06+0100', '44J63106.FIT' ],
      [ '2015-05-07T16:16:50+0000', '557G1650.FIT' ]
    ]
  end

  it 'should convert a time stamps to a file names' do
    @data.each do |t|
      Fit4Ruby::FileNameCoder.encode(Time.parse(t[0])).should == t[1]
    end
  end

  it 'should convert file names to time stamps' do
    @data.each do |t|
      Fit4Ruby::FileNameCoder.decode(t[1]).should == Time.parse(t[0]).utc
    end
  end

  it 'should fail to encode dates before 2010' do
    lambda {
      Fit4Ruby::FileNameCoder.encode(Time.parse('2009-12-31T00:00'))
    }.should raise_error
  end

  it 'should fail to encode dates after 2033' do
    lambda {
      Fit4Ruby::FileNameCoder.encode(Time.parse('2034-01-01T00:00+00:00'))
    }.should raise_error
  end

  it 'should fail to decode illegal file names' do
    [ 'A.FIT', '0123ABCD', '5ZNJ1800.FIT',
      '44063106.FIT', '44W63106.FIT',
      '557O1650.FIT', '557G6050.FIT', '557G1660.FIT' ].each do |name|
      lambda {
        Fit4Ruby::FileNameCoder.decode(name)
      }.should raise_error
    end
  end

end

