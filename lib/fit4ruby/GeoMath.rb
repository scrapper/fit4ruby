#!/usr/bin/env ruby -w
# encoding: UTF-8
#
# = Activity.rb -- Fit4Ruby - FIT file processing library for Ruby
#
# Copyright (c) 2015 by Chris Schlaeger <cs@taskjuggler.org>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of version 2 of the GNU General Public License as
# published by the Free Software Foundation.
#

module Fit4Ruby

  module GeoMath

    # This method uses the ellipsoidal earth projected to a plane formula
    # prescribed by the FCC in 47 CFR 73.208 for distances not exceeding 475
    # km /295 miles.
    # @param p1_lat Latitude of the first point in polar degrees
    # @param p1_lon Longitude of the first point in polar degrees
    # @param p2_lat Latitude of the second point in polar degrees
    # @param p2_lon Longitude of the second point in polar degrees
    # @return Distance in meters
    def GeoMath.distance(p1_lat, p1_lon, p2_lat, p2_lon)
      # Difference in latitude and longitude
      delta_lat = p2_lat - p1_lat
      delta_lon = p2_lon - p1_lon

      # Mean latitude
      mean_lat = (p1_lat + p2_lat) / 2

      # kilometers per degree of latitude difference
      k1 = 111.13209 - 0.56606 * cos(2 * mean_lat) +
           0.00120 * cos(4 * mean_lat)
      # kilometers per degree of longitude difference
      k2 = 111.41513 * cos(mean_lat) -
           0.09455 * cos(3 * mean_lat) +
           0.00012 * cos(5 * mean_lat)

      Math.sqrt(((k1 * delta_lat)) ** 2 + (k2 * delta_lon) ** 2) * 1000.0
    end

    def GeoMath.cos(deg)
      Math.cos(deg_to_rad(deg))
    end

    def GeoMath.deg_to_rad(deg)
      deg * Math::PI / 180
    end

  end

end

