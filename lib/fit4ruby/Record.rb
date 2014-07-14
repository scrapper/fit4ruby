module Fit4Ruby

  # Message: record
  #   timestamp: 2014-05-29 19:18:39
  #   position_lat: 52.51584554091096
  #   position_long: 13.372714882716537
  #   distance: 5392.59 m
  #   altitude: 17.799999999999955 m
  #   speed: 3.331 m/s
  #   vertical_oscillation: 91.7 mm
  #   stance_time_percent: 30.0 percent
  #   stance_time: 209.0 ms
  #   heart_rate: 191 bpm
  #   cadence: 85 rpm
  #   activity_type: running
  #   fractional_cadence: 0.5
  class Record

    attr_reader :timestamp, :latitude, :longitude, :altitude, :distance,
                :speed, :vertical_oscillation, :cadence, :stance_time

    def initialize
    end

    def set(field, value)
      case field
      when 'timestamp'
        @timestamp = value
      when 'position_lat'
        @latitude = value
      when 'position_long'
        @longitude = value
      when 'altitude'
        @altitude = value
      when 'distance'
        @distance = value
      when 'speed'
        @speed = value
      when 'vertical_oscillation'
        @vertical_oscillation = value
      when 'cadence'
        @cadence = 2 * value
      when 'fractional_cadence'
        @cadence += 2 * value if @cadence
      when 'stance_time'
        @stance_time = value
      else
      end
    end

    def pace
      1000.0 / (@speed * 60.0)
    end

  end

end

