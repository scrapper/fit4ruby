require 'fit4ruby/Session'
require 'fit4ruby/Lap'
require 'fit4ruby/Record'
require 'fit4ruby/FitDataRecord'

module Fit4Ruby

  class Activity < FitDataRecord

    attr_accessor :start_time, :duration, :local_start_time,
                  :sessions, :laps, :records

    def initialize
      super('activity')
      rename('timestamp', 'start_time')
      rename('local_timestamp', 'local_start_time')
      rename('total_timer_time', 'duration')
      @start_time = nil
      @local_start_time = nil
      @duration = nil
      @num_sessions = 0
      @sessions = []
      @laps = []
      @records = []
    end

    def check
      unless @start_time && @start_time >= Time.parse('1990-01-01')
        Log.error "Activity has no valid start time"
      end
      unless @duration
        Log.error "Activity has no valid duration"
      end
      unless @num_sessions == @sessions.count
        Log.error "Activity record requires #{@num_sessions}, but "
                  "#{@sessions.length} session records were found in the "
                  "FIT file."
      end
      @sessions.each { |s| s.check(self) }
    end

    def set(field, value)
      case field
      when 'timestamp'
        @start_time = value
      when 'local_timestamp'
        @local_start_time = value
      when 'total_timer_time'
        @duration = value
      when 'num_sessions'
        @num_sessions = value
      end
    end

    def method_missing(method_name, *args, &block)
      acc_fields = [ :distance ]
      avg_fields = [ :avg_speed ]

      if acc_fields.include?(method_name)
        total = 0
        @sessions.each do |s|
          total += s.send(method_name, *args, &block)
        end
        return total
      elsif avg_fields.include?(method_name)
        total = 0
        count = 0
        return 0 if @sessions.empty?

        @sessions.each do |s|
          total += s.send(method_name, *args, &block)
          count += 1
        end
        return total / count
      else
        Log.fatal "Unknown data field: #{method_name}"
      end
    end

    def new_session
      @sessions << (session = Session.new)
      session
    end

    def new_lap
      @laps << (lap = Lap.new)
      lap
    end

    def new_record
      @records << (record = Record.new)
      record
    end

    def to_s
      str = ''
      @sessions.each do |s|
        str << "\n\n" unless str.empty?
        str << s.to_s
      end
      str
    end

  end

end

