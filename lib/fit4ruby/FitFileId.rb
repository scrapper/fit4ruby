require 'fit4ruby/Converters'
require 'fit4ruby/FitDataRecord'

module Fit4Ruby

  class FitFileId < FitDataRecord

    def initialize
      super('file_id')
      @serial_number = 1234567890
      @time_created = Time.now
      @manufacturer = 'development'
      @type = 'activity'
    end

  end

end

