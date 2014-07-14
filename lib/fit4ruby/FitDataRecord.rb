require 'fit4ruby/FitMessageIdMapper'
require 'fit4ruby/GlobalFitMessages.rb'

module Fit4Ruby

  class FitDataRecord

    def initialize(record_id)
      @message = GlobalFitMessages.find_by_name(record_id)
      @renames = {}
    end

    def rename(fit_var, var)
      @renames[fit_var] = var
    end

    def write(io, id_mapper)
      global_message_number = @message.number

      # Map the global message number to the current local message number.
      unless (local_message_number = id_mapper.get_local(global_message_number))
        # If the current dictionary does not contain the global message
        # number, we need to create a new entry for it. The index in the
        # dictionary is the local message number.
        local_message_number = id_mapper.add_global(global_message_number)
        # Write the definition of the global message number to the file.
        @message.write(io, local_message_number)
      end

      # Write data record header.
      header = FitRecordHeader.new
      header.normal = 0
      header.message_type = 0
      header.local_message_type = local_message_number
      header.write(io)

      # Create a BinData::Struct object to store the data record.
      fields = []
      @message.fields.each do |field_number, field|
        bin_data_type = FitDefinitionField.fit_type_to_bin_data(field.type)
        fields << [ bin_data_type, field.name ]
      end
      bd = BinData::Struct.new(:endian => :little, :fields => fields)

      # Fill the BinData::Struct object with the values from the corresponding
      # instance variables.
      @message.fields.each do |field_number, field|
        iv = "@#{@renames[field.name] || field.name}"
        if instance_variable_defined?(iv) &&
           !(iv_value = instance_variable_get(iv)).nil?
          value = field.native_to_fit(iv_value)
        else
          # If we don't have a corresponding variable or the variable is nil
          # we write the 'undefined' value instead.
          value = FitDefinitionField.undefined_value(field.type)
        end
        bd[field.name] = value
      end

      # Write the data record to the file.
      bd.write(io)
    end

  end

end

