module Fit4Ruby

  # Message: lap
  #   timestamp: 2014-05-29 19:19:57
  #   start_time: 2014-05-29 19:16:41
  #   start_position_lat: 52.51550791785121
  #   start_position_long: 13.36703228764236
  #   end_position_lat: 52.51583841629326
  #   end_position_long: 13.373064072802663
  #   total_elapsed_time: 124.717 s
  #   total_timer_time: 124.717 s
  #   total_distance: 416.35 m
  #   total_strides: 171 strides
  #   field27: [626538455]
  #   field28: [159546869]
  #   field29: [626534414]
  #   field30: [159474907]
  #   message_index: 5
  #   total_calories: 31 kcal
  #   avg_speed: 3.338 m/s
  #   max_speed: 3.359 m/s
  #   total_ascent: 7 m
  #   total_descent: 9 m
  #   field71: []
  #   avg_vertical_oscillation: 92.2 mm
  #   avg_stance_time_percent: 32.24 percent
  #   avg_stance_time: 235.6 ms
  #   event: lap
  #   event_type: stop
  #   avg_heart_rate: 189 bpm
  #   max_heart_rate: 192 bpm
  #   avg_running_cadence: 82 strides
  #   max_running_cadence: 85 strides
  #   intensity: [no value]
  #   lap_trigger: 7
  #   sport: 1
  #   event_group: [no value]
  #   field39: []
  #   field72: []
  #   avg_fractional_cadence: 0.0234375
  #   max_fractional_cadence: 0.5
  #   total_fractional_cycles: [no value]
  class Lap

    def set(field, value)
      case field
      when 'start_time'
        @start_time = value
      when 'total_timer_time'
        @duration = value
      when 'avg_speed'
        @avg_speed = value
      when 'avg_heart_rate'
        @avg_heart_rate = value
      when 'max_heart_rate'
        @max_heart_rate = value
      when 'avg_vertical_oscillation'
        @avg_vertical_oscillation = value
      when 'avg_stance_time'
        @avg_stance_time = value
      when 'avg_running_cadence'
        @avg_running_cadence = 2 * value
      when 'avg_fraction_cadence'
        @avg_running_cadence += 2 * value
      else
      end
    end

  end

end

