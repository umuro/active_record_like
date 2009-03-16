require 'config/boot'
require 'config/environment'
require 'test_helper'

module ConceptSpace
module ActiveRecordLike

class BaseTest < NoFixtureTestCase
  abstract
  
  def model_class; method_missing :model_class; end
  def model_attribute_to_update; method_missing :model_attribute_to_update; end #e.g. [:name, "new name"]
  def model_instance; model_class.new; end
    
  context "Any Base" do
    setup do
      @object = model_class.new
    end
    teardown do
      @object.destroy
    end
   
    should "have an adapter" do
      assert_not_nil @object.adapter
    end

    context "It's Class" do
      should "have the same adapter" do
        assert_not_nil @object.class.adapter
        assert_equal @object.adapter, @object.class.adapter
      end
    end

    context "It's Adapter" do
      should "be kind of adapter" do
        assert @object.adapter.ancestors.include?(Adapter::SimpleAdapter)
      end
    end
  end

  
  context "The class" do
    should "have primary key" do
      assert_equal 'id', model_class.primary_key
    end
  end

  context "A new record" do
    setup do
      @new_record = model_instance
    end
    teardown do
      @new_record.destroy
    end
    
    context "sanity" do
      should "be able to manipulate id" do
        fake_id = "hello_world"
        @new_record.id = fake_id
        assert_equal fake_id, @new_record.id
      end
    end
    
    should "be saveable" do
      assert @new_record.save
      assert_not_nil @new_record.id
    end
    should "destroy because it does not exist anyway" do
      assert_equal @new_record, @new_record.destroy
    end
    should "not be deletable" do
      assert_equal 0, model_class.delete(@new_record.id)
    end
  end

  context "And old record" do
    setup do
      @old_record = model_instance
puts "OLD RECORD SAVING"
      @old_record.save
puts "OLD RECORD SAVED"
      assert_not_nil @old_record.id
    end
    teardown do
      @old_record.destroy
    end
    should "be found" do
puts "OLD RECORD FINDING"
      found = model_class.find(@old_record.id)
puts "OLD RECORD FOUND"
      assert found
      assert_not_nil found['id']
      assert_not_nil found.id
      assert_equal @old_record.id, found.id
    end
    should "be destroyable" do
      assert_equal @old_record, @old_record.destroy
      assert_nil model_class.find( @old_record.id )
    end
    should "be deletable" do
      assert_equal 1, model_class.delete(@old_record.id)
    end
    should "be updatable" do
      @old_record[model_attribute_to_update[0]] = model_attribute_to_update[1]
      @old_record.save
      found = model_class.find(@old_record.id)
      assert_not_nil found
      assert_equal @old_record[model_attribute_to_update[0]], found[model_attribute_to_update[0]]
    end
    should "be listable" do
      all_records = model_class.all
      assert_equal 1, all_records.size
      found = all_records.select { |record| record.id == @old_record.id}
      assert_not_nil found
    end
    #TODO offset, limit, sort order    
  end #context An old record
  
  def model_population
     10.times.collect {|i| model_instance }   
  end
  
  context "In Model Population"    do
    context "Class" do      
      should "count all"
      should "find all"
      should "find with offset"
      should "find with limit"
      should "find with sort order"    
    end
  end
  
end #class BaseTest

end
end