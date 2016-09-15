#!/usr/bin/env ruby -w
# encoding: UTF-8
#
# = FitFile_spec.rb -- Fit4Ruby - FIT file processing library for Ruby
#
# Copyright (c) 2016 by Karl-Petter Åkesson <karl-petter@yelloworb.com>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of version 2 of the GNU General Public License as
# published by the Free Software Foundation.
#
require 'spec_helper'
class Fit4Ruby::FitFile
  public :check_file_crc, :compute_crc
end

describe 'FitFile' do
  describe '#compute_crc' do
    describe 'using FIT file with header CRC' do
      
      let(:filename) {'spec/examples/WorkoutCustomTargetValues.fit'}
      subject { File.open(filename, 'rb') }
      
      it 'uses an exising test file' do
        expect(File).to exist(filename), "Download the FIT SDK from https://www.thisisant.com/resources/fit and put the .fit files from the examples/ folder into spec/examples/ folder"
      end
      
      it 'uses a valid file' do
        header_size = subject.read(1).unpack('C').first
        expect(header_size).to eq(14), "Expected header size to be 14 bytes, got #{header_size}(0x#{"%02X" % header_size}) bytes"
      end
      
      it 'calculates header CRC' do
        header_size = subject.read(1).unpack('C').first
        fit_file = Fit4Ruby::FitFile.new
        header_crc = fit_file.compute_crc(subject, 0, header_size-2)
        read_crc = subject.read(2).unpack('v').first
        expect(header_crc).to eq(read_crc), "Expected header crc to be #{"%04X" % read_crc}, got #{"%04X" % header_crc}."
      end
      
      it 'calculates file CRC' do
        header_size = subject.read(1).unpack('C').first
        fit_file = Fit4Ruby::FitFile.new
        file_crc = fit_file.compute_crc(subject, header_size, subject.size-2)
        read_crc = subject.read(2).unpack('v').first
        expect(file_crc).to eq(read_crc), "Expected file crc to be #{"%04X" % read_crc}, got #{"%04X" % file_crc}."
      end
    end
    
    describe 'using FIT file with 14 bytes header no CRC' do
      let(:filename) {'spec/examples/multi-sport-with-heartrate.fit'}
      subject { File.open(filename, 'rb') }
      
      it 'uses an exising test file' do
        expect(File).to exist(filename), "Missing file from Garmin Connect APIs Sample Data.zip. Get hold of the archive and copy the .fit files into the spec/examples/ folder"
      end
      
      it 'uses a valid file' do
        header_size = subject.read(1).unpack('C').first
        expect(header_size).to eq(14), "Expected header size to be 14 bytes, got #{header_size}(0x#{"%02X" % header_size}) bytes"
      end
      
      it 'calculates file CRC' do
        header_size = subject.read(1).unpack('C').first
        fit_file = Fit4Ruby::FitFile.new
        file_crc = fit_file.compute_crc(subject, 0, subject.size-2)
        read_crc = subject.read(2).unpack('v').first
        expect(file_crc).to eq(read_crc), "Expected file crc to be #{"%04X" % read_crc}, got #{"%04X" % file_crc}."
      end
    end
    
    describe 'using FIT file with 12 bytes header no CRC' do
      let(:filename) {'spec/examples/Activity.fit'}
      subject { File.open(filename, 'rb') }
      
      it 'uses an exising test file' do
        expect(File).to exist(filename), "Download the FIT SDK from https://www.thisisant.com/resources/fit and put the .fit files from the examples/ folder into spec/examples/ folder"
      end
      
      it 'uses a valid file' do
        header_size = subject.read(1).unpack('C').first
        expect(header_size).to eq(12), "Expected header size to be 12 bytes, got #{header_size}(0x#{"%02X" % header_size}) bytes"
      end
      
      it 'calculates file CRC' do
        header_size = subject.read(1).unpack('C').first
        fit_file = Fit4Ruby::FitFile.new
        file_crc = fit_file.compute_crc(subject, 0, subject.size-2)
        read_crc = subject.read(2).unpack('v').first
        expect(file_crc).to eq(read_crc), "Expected file crc to be #{"%04X" % read_crc}, got #{"%04X" % file_crc}."
      end
    end
  end
  
  describe '#check_file_crc' do
    describe 'using FIT file with 12 bytes header' do
      let(:filename) {'spec/examples/Activity.fit'}
      subject { File.open(filename, 'rb') }
      
      it 'uses an exising test file' do
        expect(File).to exist(filename), "Download the FIT SDK from https://www.thisisant.com/resources/fit and put the .fit files from the examples/ folder into spec/examples/ folder"
      end
      
      it 'checks file crc' do
        expect {
          fit_file = Fit4Ruby::FitFile.new
          crc = fit_file.check_file_crc(subject, false, subject.size-2)
        }.to_not raise_error # error is raised it faulty crc
      end
    end
  end
  
  describe '#read' do
    describe 'using FIT file with header CRC' do    
      let(:filename) {'spec/examples/WorkoutCustomTargetValues.fit'}
      subject { File.open(filename, 'rb') }
      
      it 'uses an exising test file' do
        expect(File).to exist(filename), "Download the FIT SDK from https://www.thisisant.com/resources/fit and put the .fit files from the examples/ folder into spec/examples/ folder"
      end
      
      it 'reads the file' do
        expect {
          fit_file = Fit4Ruby::FitFile.new.read(filename)
        }.to_not raise_error
      end
    end
    
    describe 'using FIT file with header CRC' do    
      let(:filename) {'spec/examples/Activity.fit'}
      subject { File.open(filename, 'rb') }
      
      it 'uses an exising test file' do
        expect(File).to exist(filename), "Download the FIT SDK from https://www.thisisant.com/resources/fit and put the .fit files from the examples/ folder into spec/examples/ folder"
      end
      
      it 'reads the file' do
        # check for this specific error since the file has that
        expect {
          fit_file = Fit4Ruby::FitFile.new.read(filename)
        }.to raise_error Fit4Ruby::Error, "Activity must have at least one device_info section"
      end
    end
    
    describe 'using FIT file with 14 byte header no CRC' do
      let(:filename) {'spec/examples/multi-sport-with-heartrate.fit'}
      subject { File.open(filename, 'rb') }
      
      it 'uses an exising test file' do
        expect(File).to exist(filename), "Missing file from Garmin Connect APIs Sample Data.zip. Get hold of the archive and copy the .fit files into the spec/examples/ folder"
      end
      
      it 'reads the file' do
        # check for this specific error since the file has that
        expect {
          fit_file = Fit4Ruby::FitFile.new.read(filename)
        }.to raise_error Fit4Ruby::Error, "Record 2014-04-06 14:56:53 +0200 has smaller distance (3.1) than an earlier record (2077.24)"
      end
    end
  end
end

