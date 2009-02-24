#require 'config/boot'
#require 'config/environment'
require 'test_helper'

#require 'ConceptSpace::ActiveRecordLike::Adapter::SimpleAdapterTest'.underscore

module ConceptSpace
 module ActiveRecordLike
  module Adapter

    
    class CacheAdapterTest < SimpleAdapterTest
      
      def adapter_class
        ConceptSpace::ActiveRecordLike::Adapter::CacheAdapter if self.class == CacheAdapterTest
      end
      
      def target_klass_name
        'Friend'
      end
      
      def target_rows
        [ {:name=>'Giorgio'}, {:name=>'Jim'}, {:name=>'Frits'}, {:name=>'Paul'} ] 
      end
      
      def target_update_attributes
         {:name=>'Miorgio'}
      end
      
    end #End of CacheAdapterTest

  end
 end
end