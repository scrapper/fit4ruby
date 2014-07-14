module Fit4Ruby

  class FitRecordHeader < BinData::Record

    bit1 :normal

    bit1 :message_type, :onlyif => :normal?
    bit2 :reserved, :onlyif => :normal?

    choice :local_message_type, :selection => :normal do
      bit4 0
      bit2 1
    end

    bit5 :time_offset, :onlyif => :compressed?

    def normal?
      normal == 0
    end

    def compressed?
      normal == 1
    end

  end

end
