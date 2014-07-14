require 'fit4ruby/Converters'

module Fit4Ruby

  class Session

    include Converters

    attr_reader :start_time, :duration, :distance, :strides, :ascend,
                :descent, :calories, :avg_speed, :avg_heart_rate,
                :max_heart_rate, :avg_vertical_oscillation, :avg_stance_time,
                :avg_running_cadence, :avg_running_cadence, :training_effect,
                :first_lap_index, :num_laps

    def initialize
      @laps = []
    end

    def check(activity)
      @first_lap_index.upto(@first_lap_index - @num_laps) do |i|
        if (lap = activity.lap[i])
          @laps << lap
        else
          Log.error "Session references lap #{i} which is not contained in "
                    "the FIT file."
        end
      end
    end

    def set(field, value)
      return unless value

      case field
      when 'start_time'
        @start_time = value
      when 'total_timer_time'
        @duration = value
      when 'total_distance'
        @distance = value
      when 'total_strides'
        @strides = value
      when 'total_ascent'
        @ascend = value
      when 'total_descent'
        @descent = value
      when 'total_calories'
        @calories = value
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
      when 'total_training_effect'
        @training_effect = value
      when 'first_lap_index'
        @first_lap_index = value
      when 'num_laps'
        @num_laps = value
      else
      end
    end

    def avg_stride_length
      @distance / @strides
    end

    def to_s
      <<"EOT"
Date:                     #{@start_time}
Distance:                 #{'%.2f' % (@distance / 1000.0)} km
Time:                     #{secsToHMS(@duration)}
Avg Pace:                 #{speedToPace(@avg_speed)} min/km
Total Ascend:             #{@ascend} m
Total Descend:            #{@descent} m
Calories:                 #{@calories} kCal
Avg HR:                   #{@avg_heart_rate} bpm
Max HR:                   #{@max_heart_rate} bpm
Training Effect:          #{@training_effect}
Avg Run Cadence:          #{@avg_running_cadence.round} spm
Avg Vertical Oscillation: #{'%.1f' % (@avg_vertical_oscillation / 10)} cm
Avg Ground Contact Time:  #{@avg_stance_time.round} ms
Avg Stride Length:        #{'%.2f' % (avg_stride_length / 2)} m
EOT
    end

  end

end

