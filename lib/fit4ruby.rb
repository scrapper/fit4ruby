require 'fit4ruby/FitFile'

module Fit4Ruby

  def self.read(file, dump = false)
    FitFile.new.read(file, dump)
  end

  def self.write(file, activity)
    FitFile.new.write(file, activity)
  end

end

