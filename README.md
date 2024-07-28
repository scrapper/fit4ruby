# Fit4Ruby

Fit4Ruby is a [http://www.ruby-lang.org](Ruby) libary to read and
write FIT files.

This libary is still work in progress and probably not yet ready to be
used in your application. However, you are welcome to try it and send
me comments and patches. It was developed to form the back-end of
[https://github.com/scrapper/postrunner](PostRunner).

## Supported Devices

Tested devices: Garmin FR620, Fenix 3, Fenix 5, Fenix 5X, Fenix 6X

Other Garmin devices that generate FIT files may work as well. Since I
don't have any other devices, I can't add support for them.

##Supported Operating Systems

This library was developed and tested on Linux using Ruby 2.0 (MRI).
Other operating systems that are Supported by Ruby 2.0 may probably
work as well.

##Usage

You can create an Activity.

```
require 'fit4ruby'

a = Fit4Ruby::Activity.new
a.total_timer_time = 30 * 60
a.new_user_profile({ :age => 33, :height => 1.78, :weight => 73.0,
                     :gender => 'male', :activity_class => 4.0,
                     :max_hr => 178 })

a.new_event({ :event => 'timer', :event_type => 'start_time' })
a.new_device_info({ :device_index => 0 })
a.new_device_info({ :device_index => 1, :battery_status => 'ok' })
ts = Time.now
0.upto(a.total_timer_time / 60) do |mins|
  ts += 60
  a.new_record({
    :timestamp => ts,
    :position_lat => 51.5512 - mins * 0.0008,
    :position_long => 11.647 + mins * 0.002,
    :distance => 200.0 * mins,
    :altitude => 100 + mins * 2,
    :speed => 3.1,
    :vertical_oscillation => 9 + mins * 0.02,
    :stance_time => 235.0 * mins * 0.01,
    :stance_time_percent => 32.0,
    :heart_rate => 140 + mins,
    :cadence => 75,
    :activity_type => 'running',
    :fractional_cadence => (mins % 2) / 2.0
  })

  if mins > 0 && mins % 5 == 0
    a.new_lap({ :timestamp => ts })
  end
end
a.new_session({ :timestamp => ts })
a.new_event({ :timestamp => ts, :event => 'recovery_time',
              :event_type => 'marker',
              :data => 2160 })
a.new_event({ :timestamp => ts, :event => 'vo2max',
              :event_type => 'marker', :data => 52 })
a.new_event({ :timestamp => ts, :event => 'timer',
              :event_type => 'stop_all' })
a.new_device_info({ :timestamp => ts, :device_index => 0 })
ts += 1
a.new_device_info({ :timestamp => ts, :device_index => 1,
                    :battery_status => 'low' })
ts += 120
a.new_event({ :timestamp => ts, :event => 'recovery_hr',
              :event_type => 'marker', :data => 132 })
```

Now you can have the accumulated data for laps and sessions computed.

```
a.aggregate
```

Save it to a file.

```
Fit4Ruby.write('TEST.FIT', a)
```

Or read an Activity from a file.

```
a = Fit4Ruby.read('TEST.FIT')
```

Then you can access the data in the file.

```
a.records.each do |r|
  puts "Latitude: #{r.get 'position_lat'}"
  puts "Longitude: #{r.get 'position_long'}"
end
```

Please see [`GlobalFitMessages.rb`](lib/fit4ruby/GlobalFitMessages.rb) for the data fields that
are supported for the various FIT record types.

## License

See [COPYING](COPYING) file.


