require 'test_helper'

module ConceptSpace
  module ActiveRecordLike
    module Adapter

class SimpleAdapterTest < NoFixtureTestCase
  abstract
      def adapter_class
        ## e.g.
        ## ConceptSpace::ActiveRecordLike::Adapter::CacheAdapter if self.class == CacheAdapterTest
        method_missing :adapter_class
      end
      
      def target_klass_name
        ## e.g.
        'Friend'
        method_missing :target_klass_name
      end
      
      def target_rows
        ## e.g.
        ## [ {:name=>'Giorgio'}, {:name=>'Jim'}, {:name=>'Frits'}, {:name=>'Paul'} ]
        method_missing :target_rows
      end
      
      def target_update_attributes
        ## e.g.
        ## {:name=>'Miorgio'}
        method_missing :target_attribute
      end

      context "Any Storage" do
        setup do
          @a = adapter_class
          @klass_name = target_klass_name
#          @a.delete_regardless(@klass_name)          #Dangerous
        end
        context "Empty Storage" do
          should "have 0 count" do
            assert_equal 0, @a.count(@klass_name)
          end
          
          should "have find_every return []" do
            assert_equal [], @a.find_every(@klass_name)
          end
#          should "have find_initial return nil" do
#            assert_nil @a.find_initial(@klass_name)
#          end
#          should "have find_last return nil" do
#            assert_nil @a.find_last(@klass_name)
#          end
          should "have find_some return nil" do
            assert_equal [], @a.find_some(@klass_name, [1,27,103])          
          end
          should "have find_one return nil" do
            assert_nil @a.find_one @klass_name, 1967
          end          
        end
      
        context "With One Record" do
          setup do
            @count_before_test = @a.count(@klass_name)          
            @record_rows = target_rows
            @attributes = @record_rows.first
            @record_ids = [@a.create(@klass_name, @attributes)]
            @id = @record_ids.first
            assert_equal 1, @record_ids.size
          end
          should "have one record" do
            assert_equal 1, @a.count(@klass_name) - @count_before_test
          end
          should "be able to update" do
            @a.update(@klass_name, @id, target_update_attributes)
            found = @a.find_one(@klass_name, @id)
            target_update_attributes.keys.each do |key|
              assert_equal target_update_attributes[key], found[key]
            end
          end
          context "Delete" do
            setup do
              @c1 = @a.count(@klass_name)        
              @old_id = @record_ids.first  
              @num_deleted = @a.delete(@klass_name, @old_id)
              @c2 = @a.count(@klass_name)          
            end
            should "have delete decrease the count" do
              assert_equal 1, @c1 - @c2
            end
            should "have delete return deleted count" do
              assert_equal 1, @num_deleted
            end
          end
        end
      
        context "Full Storage" do
          setup do
            @count_before_test = @a.count(@klass_name)          
            @record_rows = target_rows
            @record_ids = @record_rows.collect { | attributes |
                id = @a.create(@klass_name, attributes)
            }
            assert_equal @record_ids.size, @record_rows.size
          end
          
          teardown do
            @record_ids.each {|id| @a.delete(@klass_name, id )} 
            unless @count_before_test == @a.count(@klass_name)
              puts "TEARDOWN"
              puts "Before #{@count_before_test} Now: #{@a.count(@klass_name)}"
              all = @a.find_every(@klass_name)
              puts "All: #{all}"
            end
          end
  
          context "Create" do
            setup do
              @c1 = @a.count(@klass_name)          
              @attributes = target_rows.first
              @new_id = @a.create(@klass_name, @attributes)
            end
            teardown do
              @a.delete(@klass_name, @new_id)
            end
  
            should "not return nil" do
              assert_not_nil @new_id
            end
            
            should "not return Array" do
              assert !@new_id.kind_of?(Array)
            end
            
  #          should "update attributes id" do
  #            assert_equal @new_id, @attributes[:id]
  #          end
  
            should "have increase the count" do
              c2 = @a.count(@klass_name)
              assert_equal 1, c2 - @c1
            end
            
            should "have return a new id" do
              assert ! @record_ids.include?(@new_id)
            end
            
            should "have created record found" do
              attributes = @a.find_one(@klass_name, @new_id)
              assert_not_nil attributes
  #            assert_not_nil attributes[:id]
  #            assert_equal @new_id, attributes[:id]
            end
          end #end of Create
  
          context "Delete" do
            setup do
              @c1 = @a.count(@klass_name)        
              @old_id = @record_ids.first  
              @num_deleted = @a.delete(@klass_name, @old_id)
              @c2 = @a.count(@klass_name)          
            end
            should "have delete decrease the count" do
              assert_equal 1, @c1 - @c2
            end
            should "have delete return deleted count" do
              assert_equal 1, @num_deleted
            end
          end #end of Delete
  
          should "have find_every do it" do
            all = @a.find_every(@klass_name)
            assert_equal @record_ids.size, all.size - @count_before_test
          end
#          should "have find_initial do it" do
#            attributes = @a.find_initial(@klass_name)
#          end
#          should "have find_last do it" do
#            attributes = @a.find_last(@klass_name)
#          end
          should "have find_some do it" do
            all = @a.find_some(@klass_name, @record_ids)
            assert_equal @record_ids.size, all.size
          end
          should "have find_one do it" do
            attributes = @a.find_one(@klass_name, @record_ids.first)
            assert_equal @record_rows.first[:id], attributes[:id]
          end
  
          should "have find_every with offset" do
              all = @a.find_every(@klass_name, :offset=>2)
#              puts all.inspect
              assert_equal @record_ids.size-2, all.size
         end
          should "have find_every with limit" do
              all = @a.find_every(@klass_name, :limit=>1)
#              puts all.inspect
              assert_equal 1, all.size            
         end
          should "have find_every with offset limit" do
              all = @a.find_every(@klass_name, :offset=>2, :limit=>1)
 #             puts all.inspect
              assert_equal 1, all.size            
         end
           should "have find_every with sort order" do
              attribute_name = target_update_attributes.keys.first.to_s
              all = @a.find_every(@klass_name, :order=>"#{attribute_name} DESC")
#              puts all.inspect
              assert_equal @record_ids.size, all.size            
         end          
        end #End of Full Storage
      end #End of Any Storage  
end #End of SimpleAdapterTest

    end
  end
end