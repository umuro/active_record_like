#TODO Unify, Reduce and Eval of conditions

require 'test_helper'

module ConceptSpace
 module ActiveRecordLike
  module Adapter
    module Parser

class FindOrderTest < ConceptSpace::NoFixtureTestCase

#NOT CROSS PLATFORM
#context "Class with only grammar" do
#  setup do
#    FindOrder.maker.removeTarget
#  end
#  should "create parser" do
#    assert ! FindOrder::maker.uptodate?
#    assert_not_nil FindOrder::maker.parser
#    assert FindOrder::maker.uptodate?
#  end
#end
#context "Class with new grammar" do
#  setup do
#    FindOrder.maker.touchSource
#  end
#  should "refresh parser" do
#    assert ! FindOrder.maker.uptodate?
#    assert_not_nil FindOrder.maker.parser
#    sleep 0.3 #File system caches dates
#    assert FindOrder.maker.uptodate?
#  end
#end

extend PatternMatching

context "Conversion" do
  setup do
    @find_conditions = FindOrder.new :klass_name => 'TestClass'
  end
  #REFERENCE
  should 'ASC' do
    code = @find_conditions.convert_parse %q( Parent."id" ASC )
    assert_pattern build{ sql_sort_order(sql_ref('id', 'Parent'),  'asc') }, code
  end
  should 'DESC' do
    code = @find_conditions.convert_parse %q( Parent."id" DESC )
    assert_pattern build{ sql_sort_order(sql_ref('id', 'Parent'),  'desc') }, code
  end
  should 'TableName' do
    code = @find_conditions.convert_parse %q( "id" ASC )
    assert_pattern build{ sql_sort_order(sql_ref('id', 'TestClass'),  'asc') }, code
  end
end #context

end #class FindOrderTest

     end
    end
  end
end