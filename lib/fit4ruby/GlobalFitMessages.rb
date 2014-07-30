#!/usr/bin/env ruby -w
# encoding: UTF-8
#
# = GlobalFitMessages.rb -- Fit4Ruby - FIT file processing library for Ruby
#
# Copyright (c) 2014 by Chris Schlaeger <cs@taskjuggler.org>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of version 2 of the GNU General Public License as
# published by the Free Software Foundation.
#

require 'fit4ruby/GlobalFitMessage'

module Fit4Ruby

  GlobalFitMessages = GlobalFitMessageList.new do
    message 0, 'file_id'
    field 0, 'enum', 'type', :dict => 'file'
    field 1, 'uint16', 'manufacturer', :dict => 'manufacturer'
    field 2, 'uint16', 'product', :dict => 'product'
    field 3, 'uint32z', 'serial_number'
    field 4, 'uint32', 'time_created', :type => 'date_time'
    field 5, 'uint16', 'number'

    message 18, 'session'
    field 0, 'enum', 'event', :dict => 'event'
    field 1, 'enum', 'event_type', :dict => 'event_type'
    field 2, 'uint32', 'start_time', :type => 'date_time'
    field 3, 'sint32', 'start_position_lat', :type => 'coordinate'
    field 4, 'sint32', 'start_position_long', :type => 'coordinate'
    field 5, 'enum', 'sport', :dict => 'sport'
    field 6, 'enum', 'sub_sport', :dict => 'sub_sport'
    field 7, 'uint32', 'total_elapsed_time', :type => 'duration', :scale => 1000
    field 8, 'uint32', 'total_timer_time', :type => 'duration', :scale => 1000
    field 9, 'uint32', 'total_distance', :scale => 100, :unit => 'm'
    field 10, 'uint32', 'total_strides', :unit => 'strides'
    field 11, 'uint16', 'total_calories', :unit => 'kcal'
    field 13, 'uint16', 'total_fat_calories', :unit => 'kcal'
    field 14, 'uint16', 'avg_speed', :scale => 1000, :unit => 'm/s'
    field 15, 'uint16', 'max_speed', :scale => 1000, :unit => 'm/s'
    field 16, 'uint8', 'avg_heart_rate', :unit => 'bpm'
    field 17, 'uint8', 'max_heart_rate', :unit => 'bpm'
    field 18, 'uint8', 'avg_running_cadence', :unit => 'strides/min'
    field 19, 'uint8', 'max_running_cadence', :unit => 'strides/min'
    field 22, 'uint16', 'total_ascend', :unit => 'm'
    field 23, 'uint16', 'total_descent', :unit => 'm'
    field 24, 'uint8', 'total_training_effect', :scale => 10
    field 25, 'uint16', 'first_lap_index'
    field 26, 'uint16', 'num_laps'
    field 27, 'uint8', 'event_group'
    field 28, 'enum', 'trigger', :dict => 'session_trigger'
    field 29, 'sint32', 'nec_lat', :type => 'coordinate'
    field 30, 'sint32', 'nec_long', :type => 'coordinate'
    field 31, 'sint32', 'swc_lat', :type => 'coordinate'
    field 32, 'sint32', 'swc_long', :type => 'coordinate'
    field 81, 'enum', 'undocumented_field_81'
    field 89, 'uint16', 'avg_vertical_oscillation', :scale => 10, :unit => 'mm'
    field 90, 'uint16', 'avg_stance_time_percent', :scale => 100, :unit => 'percent'
    field 91, 'uint16', 'avg_stance_time', :scale => 10, :unit => 'ms'
    field 92, 'uint8', 'avg_fraction_cadence', :scale => 128
    field 93, 'uint8', 'max_fractional_cadence', :scale => 128
    field 94, 'uint8', 'total_fractional_cycles', :scale => 128
    field 253, 'uint32', 'timestamp', :type => 'date_time'
    field 254, 'uint16', 'message_index'

    message 19, 'lap'
    field 0, 'enum', 'event', :dict => 'event'
    field 1, 'enum', 'event_type', :dict => 'event_type'
    field 2, 'uint32', 'start_time', :type => 'date_time'
    field 3, 'sint32', 'start_position_lat', :type => 'coordinate'
    field 4, 'sint32', 'start_position_long', :type => 'coordinate'
    field 5, 'sint32', 'end_position_lat', :type => 'coordinate'
    field 6, 'sint32', 'end_position_long', :type => 'coordinate'
    field 7, 'uint32', 'total_elapsed_time', :type => 'duration', :scale => 1000
    field 8, 'uint32', 'total_timer_time', :type => 'duration', :scale => 1000
    field 9, 'uint32', 'total_distance', :scale => 100, :unit => 'm'
    field 10, 'uint32', 'total_strides', :unit => 'strides'
    field 11, 'uint16', 'total_calories', :unit => 'kcal'
    field 12, 'uint16', 'total_fat_calories', :unit => 'kcal'
    field 13, 'uint16', 'avg_speed', :scale => 1000, :unit => 'm/s'
    field 14, 'uint16', 'max_speed', :scale => 1000, :unit => 'm/s'
    field 15, 'uint8', 'avg_heart_rate', :unit => 'bpm'
    field 16, 'uint8', 'max_heart_rate', :unit => 'bpm'
    field 17, 'uint8', 'avg_running_cadence', :unit => 'strides'
    field 18, 'uint8', 'max_running_cadence', :unit => 'strides'
    field 21, 'uint16', 'total_ascent', :unit => 'm'
    field 22, 'uint16', 'total_descent', :unit => 'm'
    field 23, 'enum', 'intensity', :dict => 'intensity'
    field 24, 'enum', 'lap_trigger', :dict => 'lap_trigger'
    field 25, 'enum', 'sport', :dict => 'sport'
    field 26, 'uint8', 'event_group'
    field 27, 'sint32', 'nec_lat', :type => 'coordinate'
    field 28, 'sint32', 'nec_long', :type => 'coordinate'
    field 29, 'sint32', 'swc_lat', :type => 'coordinate'
    field 30, 'sint32', 'swc_long', :type => 'coordinate'
    field 39, 'enum', 'sub_sport', :dict => 'sub_sport'
    field 71, 'uint16', 'wkt_step_index'
    field 72, 'enum', 'undocumented_field_72'
    field 77, 'uint16', 'avg_vertical_oscillation', :scale => 10, :unit => 'mm'
    field 78, 'uint16', 'avg_stance_time_percent', :scale => 100, :unit => 'percent'
    field 79, 'uint16', 'avg_stance_time', :scale => 10, :unit => 'ms'
    field 80, 'uint8', 'avg_fractional_cadence', :scale => 128
    field 81, 'uint8', 'max_fractional_cadence', :scale => 128
    field 82, 'uint8', 'total_fractional_cycles', :scale => 128
    field 253, 'uint32', 'timestamp', :type => 'date_time'
    field 254, 'uint16', 'message_index'

    message 20, 'record'
    field 0, 'sint32', 'position_lat', :type => 'coordinate'
    field 1, 'sint32', 'position_long', :type => 'coordinate'
    field 2, 'uint16', 'altitude', :scale => 5, :offset => 500, :unit => 'm'
    field 3, 'uint8', 'heart_rate', :unit => 'bpm'
    field 4, 'uint8', 'cadence', :unit => 'rpm'
    field 5, 'uint32', 'distance', :scale => 100, :unit => 'm'
    field 6, 'uint16', 'speed', :scale => 1000, :unit => 'm/s'
    field 39, 'uint16', 'vertical_oscillation', :scale => 10, :unit => 'mm'
    field 40, 'uint16', 'stance_time_percent', :scale => 100, :unit => 'percent'
    field 41, 'uint16', 'stance_time', :scale => 10, :unit => 'ms'
    field 42, 'enum', 'activity_type', :dict => 'activity_type'
    field 53, 'uint8', 'fractional_cadence', :scale => 128 # Just a guess
    field 253, 'uint32', 'timestamp', :type => 'date_time'

    message 21, 'event'
    field 0, 'enum', 'event', :dict => 'event'
    field 1, 'enum', 'event_type', :dict => 'event_type'
    field 2, 'uint16', 'data16'
    field 3, 'uint32', 'data'
    field 4, 'uint8', 'event_group'
    field 253, 'uint32', 'timestamp', :type => 'date_time'

    # Possibly the signal quality of the best 6 satellites; Not documented in
    # FIT SDK
    message 22, 'gps_signals'
    field 0, 'uint8', 'Satellite 1'
    field 1, 'uint8', 'Satellite 2'
    field 2, 'uint8', 'Satellite 3'
    field 3, 'uint8', 'Satellite 4'
    field 4, 'uint8', 'Satellite 5'
    field 5, 'enum', 'lock_status'
    field 253, 'uint32', 'timestamp', :type => 'date_time'

    message 23, 'device_info'
    field 0, 'uint8', 'device_index'
    field 1, 'uint8', 'device_type', :dict => 'device_type'
    field 2, 'uint16', 'manufacturer', :dict => 'manufacturer'
    field 3, 'uint32z', 'serial_number'
    field 4, 'uint16', 'product', :dict => 'product'
    field 5, 'uint16', 'software_version', :scale => 100
    field 6, 'uint8', 'hardware_version'
    field 7, 'uint32', 'cum_operating_time', :type => 'duration'
    field 8, 'uint32', 'undocumented_field_8'
    field 9, 'uint8', 'undocumented_field_9'
    field 10, 'uint16', 'battery_voltage', :scale => 256, :unit => 'V'
    field 11, 'uint8', 'battery_status', :dict => 'battery_status'
    field 15, 'uint32', 'rx_packets_ok' # just a guess
    field 16, 'uint32', 'rx_packets_err' # just a guess
    field 20, 'uint8z', 'undocumented_field_20'
    field 21, 'uint16z', 'undocumented_field_21'
    field 22, 'enum', 'undocumented_field_22'
    field 23, 'uint8', 'undocumented_field_23'
    field 25, 'enum', 'undocumented_field_25'
    field 253, 'uint32', 'timestamp', :type => 'date_time'

    message 34, 'activity'
    field 0, 'uint32', 'total_timer_time', :type => 'duration',  :scale => 1000
    field 1, 'uint16', 'num_sessions'
    field 2, 'enum', 'type', :dict => 'activity_type'
    field 3, 'enum', 'event', :dict => 'event'
    field 4, 'enum', 'event_type', :dict => 'event_type'
    field 5, 'uint32', 'local_timestamp', :type => 'date_time'
    field 6, 'uint8', 'event_group'
    field 253, 'uint32', 'timestamp', :type => 'date_time'

    message 49, 'file_creator'
    field 0, 'uint16', 'software_version'
    field 1, 'uint8', 'hardware_version'

    # Not part of the official ANT SDK doc
    message 79, 'user_profile'
    field 0, 'uint16', 'undocumented_field_0' # seems to strongly correlate with vo2max
    field 1, 'uint8', 'age', :unit => 'years'
    field 2, 'uint8', 'height', :scale => 100, :unit => 'm'
    field 3, 'uint16', 'weight', :scale => 10, :unit => 'kg'
    field 4, 'enum', 'gender', :dict => 'gender'
    field 5, 'enum', 'activity_class', :scale => 10
    field 6, 'uint8', 'max_hr', :unit => 'bpm'
    field 7, 'sint8', 'undocumented_field_7' # seems to be always 1
    field 8, 'uint16', 'recovery_time', :scale => 60, :unit => 'hours'
    field 9, 'uint16', 'undocumented_field_9' # maybe activity measurement
    field 253, 'uint32', 'timestamp', :type => 'date_time'

    # Not part of the official ANT SDK doc
    message 113, 'personal_records'
    field 0, 'uint16', 'longest_distance'
    field 1, 'enum', 'undocumented_field_1' # Seems to be always 1
    field 2, 'uint32', 'distance', :scale => 100, :unit => 'm'
    # If longest_distance is 1, field 3 is the distance, not a duration!
    field 3, 'uint32', 'duration', :scale => 1000, :type => 'duration'
    field 4, 'uint32', 'start_time', :type => 'date_time'
    field 5, 'enum', 'new_record'
    field 253, 'uint32', 'timestamp', :type => 'date_time'

    # Not part of the official ANT SDK doc
    # The values in this message seem to be related to the activity history.
    # If no HRM is used, most of them are 0. Fields 4, 7, 9 and 10 always have
    # non-zero values.
    message 140, 'undocumented_140'
    field 0, 'uint8', 'max_heart_rate', :unit => 'bpm'
    field 1, 'uint8', 'undocumented_field_1'
    field 2, 'sint32', 'undocumented_field_2'
    field 3, 'sint32', 'undocumented_field_3'
    field 4, 'uint8', 'total_training_effect', :scale => 10
    field 5, 'sint32', 'undocumented_field_5'
    field 6, 'sint32', 'undocumented_field_6'
    field 7, 'sint32', 'undocumented_field_7'
    field 8, 'uint8', 'undocumented_field_8'
    field 9, 'uint16', 'recovery_time', :scale => 60, :unit => 'hours'
    field 10, 'uint16', 'undocumented_field_10' # always seems to be 340
    field 253, 'uint32', 'timestamp', :type => 'date_time'

    # Not part of the official ANT SDK doc
    message 141, 'gps_ephemeris'
    field 0, 'enum', 'valid' # 0 if no data cached, 1 else
    field 1, 'uint32', 'interval_start', :type => 'date_time'
    field 2, 'uint32', 'interval_end', :type => 'date_time'
    field 3, 'uint32', 'undocumented_field_3'
    field 4, 'sint32', 'undocumented_field_4'
    field 5, 'sint32', 'undocumented_field_5'
    field 253, 'uint32', 'timestamp', :type => 'date_time'

  end

end

