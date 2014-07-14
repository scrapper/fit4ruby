require 'fit4ruby/Log'

module Fit4Ruby

  class GlobalFitDict

    def initialize
      @entries = {}
    end

    def entry(number, name)
      if @entries.include?(number)
        Log.fatal "Entry #{number} has already been defined"
      end
      @entries[number] = name
    end

    def name(number)
      @entries[number]
    end

    def value_by_name(name)
      @entries.invert[name]
    end

  end

  class GlobalFitDictList

    def initialize(&block)
      @current_dict = nil
      @dicts = {}
      instance_eval(&block) if block_given?
    end

    def dict(name)
      if @dicts.include?(name)
        Log.fatal "Dictionary #{name} has already been defined"
      end
      @dicts[name] = @current_dict = GlobalFitDict.new
    end

    def entry(number, name)
      unless @current_dict
        Log.fatal "You must define a dictionary first"
      end
      @current_dict.entry(number, name)
    end

    def [](name)
      @dicts[name]
    end

  end

end
