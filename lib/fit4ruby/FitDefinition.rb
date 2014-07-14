require 'bindata'
require 'fit4ruby/FitDefinitionField'

module Fit4Ruby

  class FitDefinition < BinData::Record

    hide :reserved

    uint8 :reserved, :initial_value => 0
    uint8 :architecture, :initial_value => 0
    choice :global_message_number, :selection => :architecture do
      uint16le 0
      uint16be :default
    end
    uint8 :field_count
    array :fields, :type => FitDefinitionField, :initial_length => :field_count

    def endian
      architecture.snapshot == 0 ? :little : :big
    end

    def check
      fields.each { |f| f.check }
    end

    def setup(fit_message_definition)
      fit_message_definition.fields.each do |number, f|
        fdf = FitDefinitionField.new
        fdf.field_definition_number = number
        fdf.set_type(f.type)

        fields << fdf
      end
      self.field_count = fields.length
    end

  end


end

