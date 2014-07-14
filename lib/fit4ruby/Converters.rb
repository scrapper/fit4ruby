module Fit4Ruby

  module Converters

    def speedToPace(speed)
      if speed > 0.01
        pace = 1000.0 / (speed * 60.0)
        int, dec = pace.divmod 1
        "#{int}:#{'%02d' % (dec * 60)}"
      else
        "-:--"
      end
    end

    def secsToHMS(secs)
      secs = secs.to_i
      s = secs % 60
      mins = secs / 60
      m = mins % 60
      h = mins / 60
      "#{h}:#{'%02d' % m}:#{'%02d' % s}"
    end

    def secsToDHMS(secs)
      secs = secs.to_i
      s = secs % 60
      mins = secs / 60
      m = mins % 60
      hours = mins / 60
      h = hours % 24
      d = hours / 24
      "#{d} days #{h}:#{'%02d' % m}:#{'%02d' % s}"
    end

    def time_to_fit_time(t)
      (t - Time.parse('1989-12-31')).to_i
    end

    def fit_time_to_time(ft)
      Time.parse('1989-12-31') + ft.to_i
    end

  end

end

