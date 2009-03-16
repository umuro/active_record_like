module ConceptSpace
  module ActiveRecordLike
    module Adapter

class Verbose
  attr_reader :target_class
  def initialize(a_target_class)
    @target_class = a_target_class 
  end
  def method_missing(method_name, *args)
    if RAILS_ENV=='test' || RAILS_ENV=='development'
      info = "Call: #{method_name} (#{args.inspect})"  
      puts info
      Rails.logger.debug info
    end
    target_class.send(method_name, *args)
  end
  def respond_to?
    true
  end
end

    end
  end
end