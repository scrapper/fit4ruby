#!/usr/bin/env ruby -w
# encoding: UTF-8
#
# = FitTypeDefs.rb -- Fit4Ruby - FIT file processing library for Ruby
#
# Copyright (c) 2017, 2018 by Chris Schlaeger <cs@taskjuggler.org>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of version 2 of the GNU General Public License as
# published by the Free Software Foundation.
#

module Fit4Ruby

  FIT_TYPE_DEFS = [
    # FIT Type, BinData type, undefined value, bytes
    [ 'enum', 'uint8', 0xFF, 1 ],
    [ 'sint8', 'int8', 0x7F, 1 ],
    [ 'uint8', 'uint8', 0xFF, 1 ],
    [ 'sint16', 'int16', 0x7FFF, 2 ],
    [ 'uint16', 'uint16', 0xFFFF, 2 ],
    [ 'sint32', 'int32', 0x7FFFFFFF, 4 ],
    [ 'uint32', 'uint32', 0xFFFFFFFF, 4 ],
    [ 'string', 'string', '', 0 ],
    [ 'float32', 'float', 0xFFFFFFFF, 4 ],
    [ 'float63', 'double', 0xFFFFFFFF, 4 ],
    [ 'uint8z', 'uint8', 0, 1 ],
    [ 'uint16z', 'uint16', 0, 2 ],
    [ 'uint32z', 'uint32', 0, 4 ],
    [ 'byte', 'uint8', 0xFF, 1 ],
    [ 'sint64', 'int64', 0x7FFFFFFFFFFFFFFF, 8 ],
    [ 'uint64', 'uint64', 0xFFFFFFFFFFFFFFFF, 8 ],
    [ 'uint64z', 'uint64', 0, 8 ]
  ]

end

