require 'logger'

module Fit4Ruby

  # This is the Exception type that will be thrown for all unrecoverable
  # errors.
  class Error < StandardError ; end

  class ILogger < Logger

    def fatal(msg)
      super
      exit 1
    end

    def critical(msg, exception = nil)
      if exception
        raise Error, "#{msg}: #{exception.message}", exception.backtrace
      else
        raise Error, msg
      end
    end

  end

  Log = ILogger.new(STDOUT)
  Log.level = Logger::WARN
  Log.formatter = proc do |severity, time, progname, msg|
    msg + "\n"
  end

end

