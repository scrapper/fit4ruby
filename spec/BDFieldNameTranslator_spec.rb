#!/usr/bin/env ruby -w
# encoding: UTF-8
#
# = BDFieldNameTranslator_spec.rb -- Fit4Ruby - FIT file processing library for Ruby
#
# Copyright (c) 2014, 2015 by Chris Schlaeger <cs@taskjuggler.org>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of version 2 of the GNU General Public License as
# published by the Free Software Foundation.
#

$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'fit4ruby/BDFieldNameTranslator'

describe Fit4Ruby::BDFieldNameTranslator do

  include described_class

  it 'should translate "array" to "_array"' do
    expect(to_bd_field_name('array')).to eq('_array')
  end

  it 'should translate "type" to "_type"' do
    expect(to_bd_field_name('type')).to eq('_type')
  end

  it 'should NOT translate "blegga"' do
    expect(to_bd_field_name('blegga')).to eq('blegga')
  end

end

