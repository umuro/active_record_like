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

  context "Empty Storage" do
    setup do
      Parent.delete_all
    end
    #I dont put it in base test. Some storages do not have a test instance that you can delete all safely
    should "delete all" do
      Parent.delete_all
    end
  end
  
end #class CacheBaseTest

  end
end