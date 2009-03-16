require 'config/boot'
require 'config/environment'
require 'test_helper'

require 'ConceptSpace::ActiveRecordLike::CacheBaseTest'.underscore

module ConceptSpace
module ActiveRecordLike

#TODO Test inherintance is not working
class CachedFriendTest < CacheBaseTest
  def model_class
    CachedFriend if self.class == CachedFriendTest
  end
  def model_attribute_to_update
    [:name, "new name"]
  end
end

end
end