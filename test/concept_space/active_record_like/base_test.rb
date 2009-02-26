require 'config/boot'
require 'config/environment'
require 'test_helper'

module ConceptSpace
module ActiveRecordLike

class BaseTest < NoFixtureTestCase
  abstract
  
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
      assert @new_record.id
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
      @old_record.save
      assert_not_nil @old_record.id
    end
    teardown do
      @old_record.destroy
    end
    should "be found" do
      found = model_class.find(@old_record.id)
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
      @old_record[model_attribute] = "new name"
      @old_record.save
      found = model_class.find(@old_record.id)
      assert_equal @old_record[model_attribute], found[model_attribute]
    end
    should "be listable" do
      all_records = model_class.all
      assert_equal 1, all_records.size
      found = all_records.select { |record| record.id == @old_record.id}
      assert_not_nil found
    end
    #TODO offset, limit, sort order    
  end
  
end

end
end