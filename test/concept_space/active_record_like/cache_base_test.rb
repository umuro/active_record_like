require 'config/boot'
require 'config/environment'
require 'test_helper'

require 'ConceptSpace::ActiveRecordLike::BaseTest'.underscore

module ConceptSpace
module ActiveRecordLike

class CacheBaseTest < BaseTest
  abstract
  
  def model_class
    CacheBase if self.class == CacheBaseTest
  end
end

  end
end