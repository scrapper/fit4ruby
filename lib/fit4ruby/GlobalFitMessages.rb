#!/usr/bin/env ruby -w
# encoding: UTF-8
#
# = GlobalFitMessages.rb -- Fit4Ruby - FIT file processing library for Ruby
#
# Copyright (c) 2014, 2015 by Chris Schlaeger <cs@taskjuggler.org>
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
    field 6, 'uint16', 'undocumented_field_6'
    field 7, 'uint32', 'undocumented_field_7'

    message 12, 'sport'
    field 0, 'enum', 'sport', :dict => 'sport'
    field 1, 'enum', 'sub_sport', :dict => 'sub_sport'
    field 3, 'string', 'name'
    field 4, 'uint16', 'undocumented_field_4'
    field 5, 'enum', 'undocumented_field_5'
    field 6, 'enum', 'undocumented_field_6'
    field 10, 'uint8', 'undocumented_field_10', :array => true
    field 11, 'enum', 'undocumented_field_11'

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
      field :default, 'uint8', 'avg_cadence', :unit => 'rpm'
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
    field 112, 'uint32', 'time_standing', :scale => 1000, :unit => 's'
    field 113, 'uint16', 'stand_count'
    field 114, 'sint8', 'avg_left_pco', :unit => 'mm'
    field 115, 'sint8', 'avg_right_pco', :unit => 'mm'
    field 116, 'uint8', 'avg_left_power_phase', :array => true, :unit => 'degrees'
    field 117, 'uint8', 'avg_left_power_phase_peak', :array => true, :unit => 'degrees'
    field 118, 'uint8', 'avg_right_power_phase', :array => true, :unit => 'degrees'
    field 119, 'uint8', 'avg_right_power_phase_peak', :array => true, :unit => 'degrees'
    field 120, 'uint16', 'avg_power_position', :array => true, :unit => 'watts'
    field 121, 'uint16', 'max_power_position', :array => true, :unit => 'watts'
    field 122, 'uint8', 'avg_cadence_position', :array => true, :unit => 'rpm'
    field 123, 'uint8', 'max_cadence_position', :array => true, :unit => 'rpm'
    field 132, 'uint16', 'vertical_ratio', :scale => 100, :unit => '%' # guessed
    field 133, 'uint16', 'avg_gct_balance', :scale => 100, :unit => '%' # guessed
    field 134, 'uint16', 'avg_stride_length', :scale => 10000, :unit => 'm' # guessed
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
      field :default, 'uint8', 'avg_cadence', :unit => 'rpm'
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
    field 98, 'uint32', 'time_standing', :scale => 1000, :unit => 's'
    field 99, 'uint16', 'stand_count'
    field 100, 'sint8', 'avg_left_pco', :unit => 'mm'
    field 101, 'sint8', 'avg_right_pco', :unit => 'mm'
    field 102, 'uint8', 'avg_left_power_phase', :array => true, :unit => 'degrees'
    field 103, 'uint8', 'avg_left_power_phase_peak', :array => true, :unit => 'degrees'
    field 104, 'uint8', 'avg_right_power_phase', :array => true, :unit => 'degrees'
    field 105, 'uint8', 'avg_right_power_phase_peak', :array => true, :unit => 'degrees'
    field 106, 'uint16', 'avg_power_position', :array => true, :unit => 'watts'
    field 107, 'uint16', 'max_power_position', :array => true, :unit => 'watts'
    field 108, 'uint8', 'avg_cadence_position', :array => true, :unit => 'rpm'
    field 109, 'uint8', 'max_cadence_position', :array => true, :unit => 'rpm'
    field 118, 'uint16', 'vertical_ratio', :scale => 100, :unit => '%' # guessed
    field 119, 'uint16', 'avg_gct_balance', :scale => 100, :unit => '%' # guessed
    field 120, 'uint16', 'avg_stride_length', :scale => 10000, :unit => 'm' # guessed
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
    field 7, 'uint16', 'power', :unit => 'watts'
    field 11, 'sint32', 'time_from_course', :scale => 1000, :unit => 's'
    field 13, 'sint8', 'temperature', :unit => 'C'
    field 29, 'uint32', 'accumulated_power', :unit => 'watts'
    field 30, 'uint8', 'left_right_balance', :dict => 'left_right_balance'
    field 39, 'uint16', 'vertical_oscillation', :scale => 10, :unit => 'mm'
    field 40, 'uint16', 'stance_time_percent', :scale => 100, :unit => 'percent'
    field 41, 'uint16', 'stance_time', :scale => 10, :unit => 'ms'
    field 42, 'enum', 'activity_type', :dict => 'activity_type'
    field 43, 'uint8', 'left_torque_effectiveness', :scale => 2, :unit => '%'
    field 44, 'uint8', 'right_torque_effectiveness', :scale => 2, :unit => '%'
    field 45, 'uint8', 'left_pedal_smoothness', :scale => 2, :unit => '%'
    field 46, 'uint8', 'right_pedal_smoothness', :scale => 2, :unit => '%'
    field 47, 'uint8', 'combined_pedal_smoothness', :scale => 2, :unit => '%'
    field 53, 'uint8', 'fractional_cadence', :scale => 128
    field 61, 'uint16', 'undefined_value_61'
    field 63, 'uint16', 'undefined_value_63'
    field 64, 'uint16', 'undefined_value_64'
    field 65, 'uint16', 'undefined_value_65'
    field 66, 'sint16', 'undefined_value_66'
    field 67, 'sint8', 'left_pco', :unit => 'mm'
    field 68, 'sint8', 'right_pco', :unit => 'mm'
    field 69, 'uint8', 'left_power_phase', :scale => 0.7111111, :unit => 'degrees', :array => true
    field 70, 'uint8', 'left_power_phase_peak', :scale => 0.7111111, :unit => 'degrees', :array => true
    field 71, 'uint8', 'right_power_phase', :scale => 0.7111111, :unit => 'degrees', :array => true
    field 72, 'uint8', 'right_power_phase_peak', :scale => 0.7111111, :unit => 'degrees', :array => true
    field 83, 'uint16', 'vertical_ratio', :scale => 100, :unit => '%' # guessed
    field 84, 'uint16', 'gct_balance', :scale => 100, :unit => '%' # guessed
    field 85, 'uint16', 'stride_length', :scale => 10000, :unit => 'm' # guessed
    field 87, 'uint16', 'undefined_value_87' # first seen on F3 FW6.80
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
      field 'hr_high_alert', 'uint8', 'hr_high_alert', :unit => 'bpm'
      field 'hr_low_alert', 'uint8', 'hr_low_alert', :unit => 'bpm'
      field 'speed_high_alert', 'uint16', 'speed_high_alert', :scale => 1000, :unit => 'm/s'
      field 'speed_low_alert', 'uint16', 'speed_low_alert', :scale => 1000, :unit => 'm/s'
      field 'cad_high_alert', 'uint16', 'cad_high_alert', :unit => 'bpm'
      field 'cad_low_alert', 'uint16', 'cad_low_alert', :unit => 'bpm'
      field 'power_high_alert', 'uint16', 'power_high_alert', :unit => 'watts'
      field 'power_low_alert', 'uint16', 'power_low_alert', :unit => 'watts'
      field 'time_duration_alert', 'uint32', 'time_duration_alert', :scale => 100, :unit => 's'
      field 'calorie_duration_alert', 'uint32', 'calorie_duration_alert', :unit  => 'calories'
      field 'fitness_equipment', 'enum', 'fitness_equipment_state', :dict => 'fitness_equipment_state'
      field 'rider_position', 'enum', 'rider_position', :dict => 'rider_position_type'
      field 'comm_timeout', 'uint16', 'comm_timeout', :dict => 'comm_timeout_type'
      field 'recovery_hr', 'uint32', 'recovery_hr', :unit => 'bpm'
      field 'recovery_time', 'uint32', 'recovery_time', :unit => 'min'
      field 'recovery_info', 'uint32', 'recovery_info', :unit => 'min'
      field 'vo2max', 'uint32', 'vo2max'
      field 'lactate_threshold_heart_rate', 'uint32', 'lactate_threshold_heart_rate', :unit => 'bpm'
      field 'lactate_threshold_speed', 'uint32', 'lactate_threshold_speed', :scale => 1000, :unit => 'm/s'
    end
    field 4, 'uint8', 'event_group'
    field 253, 'uint32', 'timestamp', :type => 'date_time'

    # Possibly which device is used as metering source.
    # Not documented in FIT SDK, so the field names are all guesses right now.
    message 22, 'data_sources'
    field 0, 'uint8', 'distance'
    field 1, 'uint8', 'speed'
    field 2, 'uint8', 'cadence'
    field 3, 'uint8', 'elevation'
    field 4, 'uint8', 'heart_rate'
    field 5, 'enum', 'mode' # 0 or 3 seen, unknown meaning
    field 6, 'uint8', 'power' # First found in FR920XT
    field 14, 'uint8', 'calories' # First found in FR920XT
    field 253, 'uint32', 'timestamp', :type => 'date_time'

    message 23, 'device_info'
    field 0, 'uint8', 'device_index'
    field 1, 'uint8', 'device_type', :dict => 'device_type'
    field 2, 'uint16', 'manufacturer', :dict => 'manufacturer'
    field 3, 'uint32z', 'serial_number'
    alt_field 4, 'manufacturer' do
      field :default, 'uint16', 'product'
      field [ 'garmin', 'dynastream', 'dynastream_oem' ], 'uint16', 'garmin_product', :dict => 'garmin_product'
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
    field 17, 'string', 'undocumented_field_17'
    field 20, 'uint8z', 'ant_transmission_type'
    field 21, 'uint16z', 'ant_device_number'
    field 22, 'enum', 'ant_network', :dict => 'ant_network'
    field 23, 'uint8', 'undocumented_field_23'
    field 25, 'enum', 'source_type', :dict => 'source_type'
    field 253, 'uint32', 'timestamp', :type => 'date_time'

    # This message was first seen on the Fenix3HR with firmware 3.0.
    message 24, 'undocumented_24'
    # The Array contains 16 bytes. Bytes 2(lsb) and 3(msb) seem to be a
    # counter.
    field 2, 'byte', 'undocumented_field_2', :array => true

    # Message 29 is just a guess. It's not officially documented.
    # Found in LCTNS.FIT on Fenix 3
    message 29, 'location'
    field 0, 'string', 'name'
    field 1, 'sint32', 'position_lat', :type => 'coordinate'
    field 2, 'sint32', 'position_long', :type => 'coordinate'
    field 3, 'uint16', 'undocumented_field_3'
    field 4, 'uint16', 'altitude', :scale => 5, :offset => 500, :unit => 'm'
    field 5, 'uint16', 'undocumented_field_5'
    field 253, 'uint32', 'undocumented_field_253'
    field 254, 'uint16', 'location_index'

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

    message 35, 'software'
    field 3, 'uint16', 'version', :scale => 100
    field 5, 'string', 'part_number'

    message 49, 'file_creator'
    field 0, 'uint16', 'software_version'
    field 1, 'uint8', 'hardware_version'
    field 254, 'uint16', 'message_index', :dict => 'message_index'

    message 55, 'monitoring'
    field 0, 'enum', 'device_index'
    field 1, 'uint16', 'calories', :unit => 'kcal'
    field 2, 'uint32', 'distance', :scale => 100, :unit => 'm'
    field 5, 'enum', 'activity_type', :dict => 'activity_type'
    alt_field 3, 'activity_type' do
      field :default, 'uint32', 'cycles', :scale => 2, :unit => 'cycles'
      field [ 'walking', 'running' ], 'uint32', 'steps', :unit => 'steps'
      field [ 'cycling', 'swimming' ], 'uint32', 'strokes', :scale => 2, :unit => 'strokes'
    end
    field 4, 'uint32', 'active_time', :scale => 1000, :unit => 's'
    field 6, 'enum', 'activity_sub_type'
    field 7, 'enum', 'activity_level'
    field 8, 'uint16', 'distance_16', :scale => 0.1, :unit => 'km'
    field 9, 'uint16', 'cycles_16', :scale => 0.5, :unit => 'cycles'
    field 10, 'uint16', 'active_time_16', :unit => 's'
    field 11, 'uint16', 'local_timestamp'
    field 19, 'uint16', 'active_calories', :unit => 'kcal'
    field 24, 'byte', 'current_activity_type_intensity', :type => 'activity_intensity'
    field 26, 'uint16', 'timestamp_16', :unit => 's'
    field 27, 'uint8', 'heart_rate', :unit => 'bpm'
    field 29, 'uint16', 'duration_min', :unit => 'min'
    field 30, 'uint32', 'duration', :unit => 's'
    field 31, 'uint32', 'ascent', :scale => 1000, :unit => 'm'
    field 32, 'uint32', 'descent', :scale => 1000, :unit => 'm'
    field 33, 'uint16', 'moderate_activity_minutes', :unit => 'minutes'
    field 34, 'uint16', 'vigorous_activity_minutes', :unit => 'minutes'
    field 35, 'uint32', 'floors_climbed', :scale => 1000, :unit => 'm' # just a guess, around 3.048m (10ft) per floor
    field 36, 'uint32', 'floors_descended', :scale => 1000, :unit => 'm' # just a guess
    field 37, 'uint16', 'weekly_moderate_activity_minutes', :unit => 'minutes' # just a guess
    field 38, 'uint16', 'weekly_vigorous_activity_minutes', :unit => 'minutes' # just a guess
    field 253, 'uint32', 'timestamp', :type => 'date_time'

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
    field 0, 'uint16', 'metmax', :scale => 1000, :unit => 'MET' # VO2max / 3.5
    field 1, 'uint8', 'age', :unit => 'years'
    field 2, 'uint8', 'height', :scale => 100, :unit => 'm'
    field 3, 'uint16', 'weight', :scale => 10, :unit => 'kg'
    field 4, 'enum', 'gender', :dict => 'gender'
    field 5, 'enum', 'activity_class', :scale => 10
    field 6, 'uint8', 'max_hr', :unit => 'bpm'
    field 7, 'sint8', 'undocumented_field_7' # seems to be always 1
    field 8, 'uint16', 'recovery_time', :scale => 60, :unit => 'hours'
    field 9, 'uint16', 'undocumented_field_9' # maybe activity measurement
    field 10, 'uint8', 'undocumented_field_10'
    field 11, 'uint16', 'running_lactate_threshold_heart_rate', :unit => 'bpm'
    field 12, 'uint16', 'undocumented_field_12'
    field 13, 'uint16', 'undocumented_field_13'
    field 14, 'uint8', 'undocumented_field_14'
    field 253, 'uint32', 'timestamp', :type => 'date_time'

    message 101, 'length'
    field 0, 'enum', 'event', :dict => 'event'
    field 1, 'enum', 'event_type', :dict => 'event_type'
    field 2, 'uint32', 'date_time', :type => 'date_time'
    field 3, 'uint32', 'total_elapsed_time', :scale => 1000, :unit => 's'
    field 4, 'uint32', 'total_timer_time', :scale => 1000, :unit => 's'
    field 5, 'uint16', 'total_strokes', :unit => 'strokes'
    field 6, 'uint16', 'avg_speed', :scale => 1000, :unit => 'm/s'
    field 7, 'enum', 'swim_stroke', :dict => 'swim_stroke'
    field 9, 'uint8', 'avg_swimming_cadence', :unit => 'strokes/min'
    field 10, 'uint8', 'event_group'
    field 11, 'uint16', 'total_calories', :unit => 'kcal'
    field 12, 'enum', 'length_type', :dict => 'length_type'
    field 18, 'uint16', 'player_score'
    field 19, 'uint16', 'opponent_score'
    field 253, 'uint32', 'timestamp', :type => 'date_time'
    field 254, 'uint16', 'message_index'

    message 103, 'monitoring_info'
    field 0, 'uint32', 'local_time', :type => 'date_time'
    field 1, 'enum', 'activity_type', :array => true, :dict => 'activity_type'
    field 3, 'uint16', 'cycles_to_distance', :array => true, :scale => 5000, :unit => 'm/cycle'
    field 4, 'uint16', 'cycles_to_calories', :array => true, :scale => 5000, :unit => 'kcal/cycle'
    field 5, 'uint16', 'resting_metabolic_rate', :unit => 'kcal/day'
    # Just a guess, not officially documented
    field 7, 'uint32', 'goal_cycles', :array => true
    field 253, 'uint32', 'timestamp', :type => 'date_time'

    # Not part of the official ANT SDK doc
    message 113, 'personal_records'
    field 0, 'uint16', 'longest_distance'
    field 1, 'enum', 'sport', :dict => 'sport'
    field 2, 'uint32', 'distance', :scale => 100, :unit => 'm'
    # If longest_distance is 1, field 3 is the distance, not a duration!
    field 3, 'uint32', 'duration', :scale => 1000, :type => 'duration'
    field 4, 'uint32', 'start_time', :type => 'date_time'
    field 5, 'enum', 'new_record'
    field 253, 'uint32', 'timestamp', :type => 'date_time'

    # Not part of the official ANT SDK doc
    # It shows up in swimming activities.
    message 125, 'undocumented_125'
    field 1, 'uint8', 'undocumented_field_1', :array => true
    field 2, 'uint16', 'undocumented_field_2', :array => true
    field 3, 'uint16', 'undocumented_field_3'
    field 4, 'uint8', 'undocumented_field_4'
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
    field 13, 'uint8', 'undocumented_field_13'
    field 14, 'uint16', 'running_lactate_threshold_heart_rate', :unit => 'bpm'
    field 15, 'uint16', 'running_lactate_threshold_speed', :scale => 100, :unit => 'm/s'
    field 16, 'uint16', 'undocumented_field_16' # very correlated to 14 and 15
    field 17, 'sint8', 'undocumented_field_17'
    field 18, 'uint8', 'undocumented_field_18'
    field 19, 'uint8', 'undocumented_field_19'
    field 253, 'uint32', 'timestamp', :type => 'date_time'

    # Not part of the official ANT SDK doc. The message name is guessed and
    # may change in the future.
    message 141, 'epo_data'
    field 0, 'enum', 'valid' # 0 if no data cached, 1 else
    field 1, 'uint32', 'interval_start', :type => 'date_time'
    field 2, 'uint32', 'interval_end', :type => 'date_time'
    field 3, 'uint32', 'undocumented_field_3'
    field 4, 'sint32', 'undocumented_field_4'
    field 5, 'sint32', 'undocumented_field_5'
    field 253, 'uint32', 'timestamp', :type => 'date_time'

    message 211, 'undocumented_211'
    field 0, 'uint8', 'undocumented_field_0'
    field 253, 'uint32', 'timestamp', :type => 'date_time'

  end

end

