#!/usr/bin/env ruby -w
# encoding: UTF-8
#
# = Converters_spec.rb -- Fit4Ruby - FIT file processing library for Ruby
#
# Copyright (c) 2014, 2015 by Chris Schlaeger <cs@taskjuggler.org>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of version 2 of the GNU General Public License as
# published by the Free Software Foundation.
#

$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'fit4ruby/Converters'

describe Fit4Ruby::Converters do

  include described_class

  describe '#conversion_factor' do

    it 'should return one for matching "from" and "to" units' do
      expect(conversion_factor('C', 'C')).to be(1.0)
    end

    it 'should raise an error for unsupported "from" unit' do
      expect {
        conversion_factor('F', 'C')
      }.to raise_error(Fit4Ruby::Error)
    end

    it 'should raise an error for unsupported "to" unit' do
      expect {
        conversion_factor('C', 'K')
      }.to raise_error(Fit4Ruby::Error)
    end

    it 'should return correct Celsius-to-Fahrenheit factor' do
      expect(conversion_factor('C', 'F')).to eq(9.0 / 5.0)
    end

  end

  describe '#conversion_offset' do

    it 'should return zero for missing "from" unit' do
      expect(conversion_offset(nil, nil)).to be_zero
    end

    it 'should return zero for missing "to" unit' do
      expect(conversion_offset('C', nil)).to be_zero
    end

    it 'should return zero for unmapped "to" unit' do
      expect(conversion_offset('C', 'K')).to be_zero
    end

    it 'should return zero for unmapped "from" unit' do
      expect(conversion_offset('F', 'C')).to be_zero
    end

    it 'should return zero for matching "from"/"to" units' do
      expect(conversion_offset('C', 'C')).to be_zero
    end

    it 'should return correct Celsius-to-Fahrenheit offset' do
      expect(conversion_offset('C', 'F')).to eq(32)
    end

  end

end

