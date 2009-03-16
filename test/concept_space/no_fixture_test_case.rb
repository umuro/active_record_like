require 'active_support/test_case'
require 'patternmatching'

module ConceptSpace
class NoFixtureTestCase < ActiveSupport::TestCase
  def setup_fixtures   
  end
  def tear_downfixtures
  end

  def model_class; method_missing :model_class; end
  def model_instance; model_class.new; end

class << self
  def abstract
    @abstract = true
  end

  def suite_with_abstract
    if @abstract
      Test::Unit::TestSuite.new
    else
      suite_without_abstract
    end
  end
  alias_method_chain :suite, :abstract
end #class

def assert_pattern source, target, explanation=''
  _wrap_assertion do
    begin
      PatternMatching::Collector.walk(source, target, {})
    rescue PatternMatching::NotMatched
      msg =  explanation+" Pattern Match Failed!\n\tExpected: #{source.inspect}\n\tInstead of: #{target.inspect}"
      puts msg
      assert false, msg
    end
  end
end #def

def assert_pattern_fail source, target, explanation=''
  _wrap_assertion do
    begin
      PatternMatching::Collector.walk(source, target, {})
      msg =  explanation+" Pattern Match Succeeded!\n\tUnexpected: #{target.inspect}"
      assert false, msg
    rescue PatternMatching::NotMatched
    end
  end
end #def

def build &block
  PatternMatching.build &block
end

end #class
end