#!/usr/bin/env ruby -w
# encoding: UTF-8
#
# = FileNameCoder.rb -- Fit4Ruby - FIT file processing library for Ruby
#
# Copyright (c) 2014 by Chris Schlaeger <cs@taskjuggler.org>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of version 2 of the GNU General Public License as
# published by the Free Software Foundation.
#

module Fit4Ruby

  # This class provides encoder and decoder for the FIT file names typically
  # used for activies and monitor data files.
  class FileNameCoder

    CodeBook = 0.upto(9).map{ |i| (?0.ord + i).chr} +
               0.upto(25).map{ |i|(?A.ord + i).chr}

    # Convert a Time to a corresponding FIT file name.
    # @param [Time] time stamp
    # @return [String] FIT file name with extension '.FIT'
    def FileNameCoder::encode(time)
      utc = time.utc
      if (year = utc.year) < 2010 || year > 2033
        raise ArgumentError, "Year must be between 2010 and 2033"
      end
      year = CodeBook[year - 2010]
      month = CodeBook[utc.month]
      day = CodeBook[utc.day]
      hour = CodeBook[utc.hour]
      minutes = "%02d" % utc.min
      seconds = "%02d" % utc.sec

      year + month + day + hour + minutes + seconds + '.FIT'
    end

    # Convert a FIT file name into the corresponding Time value.
    # @param file_name [String] FIT file name. This can be a full path name
    #        but must end with a '.FIT' extension.
    # @return [Time] corresponding Time value
    def FileNameCoder::decode(file_name)
      base = File.basename(file_name.upcase)
      unless /\A[0-9A-Z]{4}[0-9]{4}\.FIT\z/ =~ base
        raise ArgumentError, "#{file_name} is not a valid FIT file name"
      end

      year = 2010 + CodeBook.index(base[0])
      month = CodeBook.index(base[1])
      day = CodeBook.index(base[2])
      hour = CodeBook.index(base[3])
      minutes = base[4,2].to_i
      seconds = base[6,2].to_i
      if month == 0 || month > 12 || day == 0 || day > 31 ||
         hour >= 24 || minutes >= 60 || seconds >= 60
        raise ArgumentError, "#{file_name} is not a valid FIT file name"
      end

      Time.new(year, month, day, hour, minutes, seconds, "+00:00")
    end

  end

end

