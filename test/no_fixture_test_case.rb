require 'active_support/test_case'

class NoFixtureTestCase < ActiveSupport::TestCase
  def setup_fixtures   
  end
  def tear_downfixtures
  end

  def model_class; method_missing :model_class; end
  def model_attribute; method_missing :model_attribute; end
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
end

end

