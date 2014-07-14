module Fit4Ruby

  class FitFilter < Struct.new(:record_numbers, :record_indexes, :field_names,
                               :ignore_undef)

    def initialize
      super
      self[:ignore_undef] = false
    end

  end

end

