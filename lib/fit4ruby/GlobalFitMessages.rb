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
    alt_field 2, 'manufacturer' do
      field :default, 'uint16', 'product'
      field 'garmin', 'uint16', 'garmin_product', :dict => 'garmin_product'
    end
    field 3, 'uint32z', 'serial_number'
    field 4, 'uint32', 'time_created', :type => 'date_time'
    field 5, 'uint16', 'number'

    message 12, 'sport'
    field 0, 'enum', 'sport', :dict => 'sport'
    field 1, 'enum', 'sub_sport', :dict => 'sub_sport'
    field 3, 'string', 'name'
    field 4, 'uint16', 'undocumented_field_4'
    field 5, 'enum', 'undocumented_field_5'
    field 6, 'enum', 'undocumented_field_6'
    field 10, 'uint8', 'undocumented_field_10', :array => true

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
    alt_field 10, 'sport' do
      field :default, 'uint32', 'total_cycles', :unit => 'cycles'
      field [ 'running', 'walking' ], 'uint32', 'total_strides', :unit => 'strides'
    end
    field 11, 'uint16', 'total_calories', :unit => 'kcal'
    field 13, 'uint16', 'total_fat_calories', :unit => 'kcal'
    field 14, 'uint16', 'avg_speed', :scale => 1000, :unit => 'm/s'
    field 15, 'uint16', 'max_speed', :scale => 1000, :unit => 'm/s'
    field 16, 'uint8', 'avg_heart_rate', :unit => 'bpm'
    field 17, 'uint8', 'max_heart_rate', :unit => 'bpm'
    alt_field 18, 'sport' do
      field :default, 'uint8', 'avg_candence', :unit => 'rpm'
      field 'running', 'uint8', 'avg_running_cadence', :unit => 'strides/min'
    end
    alt_field 19, 'sport' do
      field :default, 'uint8', 'max_cadence', :unit => 'rpm'
      field 'running', 'uint8', 'max_running_cadence', :unit => 'strides/min'
    end
    field 20, 'uint16', 'avg_power', :unit => 'watts'
    field 21, 'uint16', 'max_power', :unit => 'watts'
    field 22, 'uint16', 'total_ascent', :unit => 'm'
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
    field 33, 'uint16', 'undefined_value_33'
    field 34, 'uint16', 'normalized_power', :unit => 'watts'
    field 35, 'uint16', 'training_stress_score', :scale => 10, :unit => 'tss'
    field 36, 'uint16', 'intensity_factor', :scale => 1000, :unit => 'if'
    field 37, 'uint16', 'left_right_balance', :dict => 'left_right_balance_100'
    field 41, 'uint32', 'avg_stroke_count', :scale => 10, :unit => 'strokes/lap'
    field 42, 'uint16', 'avg_stroke_distance', :scale => 100, :unit => 'm'
    field 43, 'enum', 'swim_stroke', :dict => 'swim_stroke'
    field 44, 'uint16', 'pool_length', :scale => 100, :unit => 'm'
    field 45, 'uint16', 'undefined_value_45'
    field 46, 'enum', 'pool_length_unit', :dict => 'display_measure'
    field 47, 'uint16', 'num_active_length', :unit => 'lengths'
    field 48, 'uint32', 'total_work', :unit => 'J'
    field 57, 'sint8', 'avg_temperature', :unit => 'C'
    field 58, 'sint8', 'max_temperature', :unit => 'C'
    field 65, 'uint32', 'time_in_hr_zone', :array => true, :scale => 1000, :unit => 's'
    field 68, 'uint32', 'time_in_power_zone', :array => true, :scale => 1000, :unit => 's'
    field 78, 'uint32', 'undocumented_field_78'
    field 79, 'uint16', 'undocumented_field_79'
    field 80, 'uint16', 'undocumented_field_80'
    field 81, 'enum', 'undocumented_field_81'
    field 89, 'uint16', 'avg_vertical_oscillation', :scale => 10, :unit => 'mm'
    field 90, 'uint16', 'avg_stance_time_percent', :scale => 100, :unit => 'percent'
    field 91, 'uint16', 'avg_stance_time', :scale => 10, :unit => 'ms'
    field 92, 'uint8', 'avg_fractional_cadence', :scale => 128, :unit => 'rpm'
    field 93, 'uint8', 'max_fractional_cadence', :scale => 128, :unit => 'rpm'
    field 94, 'uint8', 'total_fractional_cycles', :scale => 128, :unit => 'cycles'
    field 95, 'uint16', 'avg_total_hemoglobin_conc', :array => true, :scale => 100, :unit => 'g/dL'
    field 96, 'uint16', 'min_total_hemoglobin_conc', :array => true, :scale => 100, :unit => 'g/dL'
    field 97, 'uint16', 'max_total_hemoglobin_conc', :array => true, :scale => 100, :unit => 'g/dL'
    field 101, 'uint8', 'avg_left_torque_effectiveness', :scale => 2, :unit => 'percent'
    field 102, 'uint8', 'avg_right_torque_effectiveness', :scale => 2, :unit => 'percent'
    field 103, 'uint8', 'avg_left_pedal_smoothness', :scale => 2, :unit => 'percent'
    field 104, 'uint8', 'avg_right_pedal_smoothness', :scale => 2, :unit => 'percent'
    field 105, 'uint8', 'avg_combined_pedal_smoothness', :scale => 2, :unit => 'percent'
    field 107, 'uint16', 'undefined_value_107'
    field 108, 'uint16', 'undefined_value_108'
    field 109, 'uint8', 'undefined_value_109'
    field 110, 'string', 'undefined_value_110'
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
    field 25, 'enum', 'sport', :dict => 'sport'
    alt_field 10, 'sport' do
      field :default, 'uint32', 'total_cycles', :unit => 'cycles'
      field [ 'running', 'walking' ], 'uint32', 'total_strides', :unit => 'strides'
    end
    field 11, 'uint16', 'total_calories', :unit => 'kcal'
    field 12, 'uint16', 'total_fat_calories', :unit => 'kcal'
    field 13, 'uint16', 'avg_speed', :scale => 1000, :unit => 'm/s'
    field 14, 'uint16', 'max_speed', :scale => 1000, :unit => 'm/s'
    field 15, 'uint8', 'avg_heart_rate', :unit => 'bpm'
    field 16, 'uint8', 'max_heart_rate', :unit => 'bpm'
    alt_field 17, 'sport' do
      field :default, 'uint8', 'avg_candence', :unit => 'rpm'
      field 'running', 'uint8', 'avg_running_cadence', :unit => 'strides/min'
    end
    alt_field 18, 'sport' do
      field :default, 'uint8', 'max_cadence', :unit => 'rpm'
      field 'running', 'uint8', 'max_running_cadence', :unit => 'strides/min'
    end
    field 19, 'uint16', 'avg_power', :unit => 'watts'
    field 20, 'uint16', 'max_power', :unit => 'watts'
    field 21, 'uint16', 'total_ascent', :unit => 'm'
    field 22, 'uint16', 'total_descent', :unit => 'm'
    field 23, 'enum', 'intensity', :dict => 'intensity'
    field 24, 'enum', 'lap_trigger', :dict => 'lap_trigger'
    field 26, 'uint8', 'event_group'
    field 27, 'sint32', 'nec_lat', :type => 'coordinate'
    field 28, 'sint32', 'nec_long', :type => 'coordinate'
    field 29, 'sint32', 'swc_lat', :type => 'coordinate'
    field 30, 'sint32', 'swc_long', :type => 'coordinate'
    field 32, 'uint16', 'num_length', :unit => 'lengths'
    field 33, 'uint16', 'normalized_power', :unit => 'watts'
    field 34, 'uint16', 'left_right_balance', :dict => 'left_right_balance_100'
    field 35, 'uint16', 'first_length_index'
    field 37, 'uint16', 'avg_stroke_distance', :scale => 100, :unit => 'm'
    field 38, 'enum', 'swim_stroke', :dict => 'swim_stroke'
    field 39, 'enum', 'sub_sport', :dict => 'sub_sport'
    field 40, 'uint16', 'num_active_length', :unit => 'lengths'
    field 41, 'uint32', 'total_work', :scale => 'J'
    field 57, 'uint32', 'time_in_hr_zone', :array => true, :scale => 1000, :unit => 's'
    field 60, 'uint32', 'avg_pos_vertical_speed', :scale => 1000, :unit => 'm/s'
    field 70, 'uint32', 'undefined_value_70'
    field 71, 'uint16', 'wkt_step_index'
    field 72, 'enum', 'undocumented_field_72'
    field 73, 'uint16', 'undefined_value_73'
    field 77, 'uint16', 'avg_vertical_oscillation', :scale => 10, :unit => 'mm'
    field 78, 'uint16', 'avg_stance_time_percent', :scale => 100, :unit => 'percent'
    field 79, 'uint16', 'avg_stance_time', :scale => 10, :unit => 'ms'
    field 80, 'uint8', 'avg_fractional_cadence', :scale => 128
    field 81, 'uint8', 'max_fractional_cadence', :scale => 128
    field 82, 'uint8', 'total_fractional_cycles', :scale => 128
    field 90, 'uint16', 'undefined_value_90'
    field 91, 'uint8', 'avg_left_torque_effectiveness', :scale => 2, :unit => 'percent'
    field 92, 'uint8', 'avg_right_torque_effectiveness', :scale => 2, :unit => 'percent'
    field 93, 'uint8', 'avg_left_pedal_smoothness', :scale => 2, :unit => 'percent'
    field 94, 'uint8', 'avg_right_pedal_smoothness', :scale => 2, :unit => 'percent'
    field 95, 'uint8', 'avg_combined_pedal_smoothness', :scale => 2, :unit => 'percent'
    field 96, 'uint16', 'undefined_value_96'
    field 97, 'uint16', 'undefined_value_97'
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
    field 53, 'uint8', 'fractional_cadence', :scale => 128
    field 61, 'uint16', 'undefined_value_61'
    field 66, 'sint16', 'undefined_value_66'
    field 253, 'uint32', 'timestamp', :type => 'date_time'

    message 21, 'event'
    field 0, 'enum', 'event', :dict => 'event'
    field 1, 'enum', 'event_type', :dict => 'event_type'
    field 2, 'uint16', 'data16'
    alt_field 3, 'event' do
      field :default, 'uint32', 'data'
      field 'timer', 'enum', 'timer_trigger', :dict => 'timer_trigger'
      field 'course_point', 'enum', 'message_index', :dict => 'message_index'
      field 'battery', 'uint16', 'battery_level', :scale => 1000, :unit => 'V'
      field 'recovery_hr', 'uint32', 'recovery_hr', :unit => 'bpm'
      field 'recovery_time', 'uint32', 'recovery_time', :unit => 'min'
      field 'vo2max', 'uint32', 'vo2max'
    end
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
    field 6, 'uint8', 'undocumented_field_6' # First found in FR920XT
    field 14, 'uint8', 'undocumented_field_14' # First found in FR920XT
    field 253, 'uint32', 'timestamp', :type => 'date_time'

    message 23, 'device_info'
    field 0, 'uint8', 'device_index'
    field 1, 'uint8', 'device_type', :dict => 'device_type'
    field 2, 'uint16', 'manufacturer', :dict => 'manufacturer'
    field 3, 'uint32z', 'serial_number'
    alt_field 4, 'manufacturer' do
      field :default, 'uint16', 'product'
      field 'garmin', 'uint16', 'garmin_product', :dict => 'garmin_product'
    end
    field 5, 'uint16', 'software_version', :scale => 100
    field 6, 'uint8', 'hardware_version'
    field 7, 'uint32', 'cum_operating_time', :type => 'duration'
    field 8, 'uint32', 'undocumented_field_8'
    field 9, 'uint8', 'undocumented_field_9'
    field 10, 'uint16', 'battery_voltage', :scale => 256, :unit => 'V'
    field 11, 'uint8', 'battery_status', :dict => 'battery_status'
    field 15, 'uint32', 'rx_packets_ok' # just a guess
    field 16, 'uint32', 'rx_packets_err' # just a guess
    field 20, 'uint8z', 'ant_transmission_type'
    field 21, 'uint16z', 'ant_device_number'
    field 22, 'enum', 'ant_network', :dict => 'ant_network'
    field 23, 'uint8', 'undocumented_field_23'
    field 25, 'enum', 'source_type', :dict => 'source_type'
    field 253, 'uint32', 'timestamp', :type => 'date_time'

    message 33, 'totals'
    field 0, 'uint32', 'timer_time', :unit => 's'
    field 1, 'uint32', 'distance', :unit => 'm'
    field 2, 'uint32', 'calories', :unit => 'kcal'
    field 3, 'enum', 'sport', :dict => 'sport'
    field 4, 'uint32', 'elapsed_time', :unit => 's'
    field 5, 'uint16', 'sessions'
    field 6, 'uint32', 'active_time', :unit => 's'
    field 253, 'uint32', 'timestamp', :type => 'date_time'
    field 254, 'uint16', 'message_index'

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

    message 72, 'training_file'
    field 0, 'enum', 'type'
    field 1, 'uint16', 'manufacturer', :dict => 'manufacturer'
    alt_field 2, 'manufacturer' do
      field :default, 'uint16', 'product'
      field 'garmin', 'uint16', 'garmin_product', :dict => 'garmin_product'
    end
    field 3, 'uint32z', 'serial_number'
    field 4, 'uint32', 'time_created', :type => 'date_time'
    field 253, 'uint32', 'timestamp', :type => 'date_time'

    message 78, 'hrv'
    field 0, 'uint16', 'time', :array => true, :scale => 1000, :unit => 's'

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
    field 11, 'enum', 'undocumented_field_11'
    field 12, 'enum', 'undocumented_field_12'
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

