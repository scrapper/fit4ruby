#!/usr/bin/env ruby -w
# encoding: UTF-8
#
# = GeoMath_spec.rb -- Fit4Ruby - FIT file processing library for Ruby
#
# Copyright (c) 2014, 2015 by Chris Schlaeger <cs@taskjuggler.org>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of version 2 of the GNU General Public License as
# published by the Free Software Foundation.
#

$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'fit4ruby/GeoMath'

describe Fit4Ruby::GeoMath do

  p0_lat = 48.180506536737084
  p0_lon = 11.611978523433208

  [
    # latitude, longitude, distance to p0 in meters
    [ 48.180506536737084, 11.611978523433208, 0.0 ],
    [ 48.18047543987632, 11.61195664666593, 3.821 ],
    [ 48.18034409545362, 11.611852794885635, 20.339 ],
    [ 48.17970883101225, 11.611351054161787, 100.225 ]
  ].each_with_index do |p, index|
    it "should compute a distance between 2 points (##{index})" do
      expect(described_class.distance(
        p0_lat, p0_lon, p[0], p[1])).to be_within(0.001).of(p[2])
    end
  end

end

