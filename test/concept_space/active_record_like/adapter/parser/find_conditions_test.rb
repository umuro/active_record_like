#TODO Unify, Reduce and Eval of conditions

require 'test_helper'

#Introduce Pattern Matching
#Some libraries to give thought:
#http://patternmatching.rubyforge.org/
#Functional: http://etorreborre.blogspot.com/2007/04/pattern-matching-with-ruby.html 
#Logic: http://eigenclass.org/hiki.rb?tiny+prolog+in+ruby
#LISP: http://www.randomhacks.net/articles/2005/12/03/why-ruby-is-an-acceptable-lisp
#CHEAT http://www.rubytips.org/2007/09/11/really-compact-ruby-quick-reference-guide/

#For More SQL Syntax
#http://msdn.microsoft.com/en-us/library/ms189773.aspx
#http://www.cs.umbc.edu/help/oracle8/server.815/a67779/operator.htm#997691
#http://mckoi.com/database/InternalFunctions.html#2x
#http://www.mckoi.com/database/SQLSyntax.html#15
#http://www.firstsql.com/tutor2.htm
#http://msdn.microsoft.com/en-us/library/ms179899.aspx

module ConceptSpace
 module ActiveRecordLike
  module Adapter
    module Parser

class FindConditionsTest < ConceptSpace::NoFixtureTestCase

context "Class with only grammar" do
  setup do
    FindConditions.maker.removeTarget
  end
  should "create parser" do
    assert ! FindConditions.maker.uptodate?
    assert_not_nil FindConditions.maker.parser
    assert FindConditions.maker.uptodate?
  end
end
context "Class with new grammar" do
  setup do
    FindConditions.maker.touchSource
  end
  should "refresh parser" do
    assert ! FindConditions.maker.uptodate?
    assert_not_nil FindConditions.maker.parser
    sleep 0.3 #File system caches dates
    assert FindConditions.maker.uptodate?
  end
end

extend PatternMatching
context "PatternMaching" do
  should "nodes equal" do
    a = build {sql_ref('id', 'table')}
    b = build {sql_ref('id', 'table')}
    c = build {sql_ref('id', 'mable')}
    assert_equal a, b
    assert_not_equal a, c
  end
end

context "For Active Scaffold" do
should %q("Parent".parent_id = 'a_parent_id') do
  answer = FindConditions.parse %q("Parent".parent_id = 'a_parent_id')
  assert_pattern build {sql_msg(sql_ref('parent_id', 'Parent'), '=', 'a_parent_id' )}, answer.code
  #COULD Optimize for index  answer.name = :message
end
should "Parent.id = 'a_parent_id'" do
  answer = FindConditions.parse "Parent.id = 'a_parent_id'"
  assert_pattern build {sql_msg(sql_ref('id', 'Parent'), '=', 'a_parent_id' )}, answer.code
  #SHOULD Optimize for index
end
should %q("Property".parent_id = 'a_parent_id') do
  answer = FindConditions.parse %q("Property".parent_id = 'a_parent_id')
  assert_pattern build {sql_msg(sql_ref('parent_id', 'Property'), '=', 'a_parent_id' )}, answer.code
  #SHOULD Optimize for index
end
should "Property.parent_id = 'a_parent_id'"  do
  answer = FindConditions.parse "Property.parent_id = 'a_parent_id'"
  assert_pattern build {sql_msg(sql_ref('parent_id', 'Property'), '=', 'a_parent_id' )}, answer.code
  #SHOULD Optimize for index
end
should %q(LOWER(Parent."id") LIKE '%parent_2%' OR LOWER(Parent."name") LIKE '%parent_2%' ) do
  answer = FindConditions.parse %q(LOWER(Parent."id") LIKE '%parent_2%' OR LOWER(Parent."name") LIKE '%parent_2%' ) 
  assert_pattern build {sql_msg(sql_msg(sql_msg(sql_ref('id', 'Parent'), 'lower'), 'like', "%parent_2%"), 'or', :_)}, answer.code
end

#Base sanitize_sql_for_conditions converts those cases into sql
#context "For compatibility" do
#should %q(['status = ? and active = ?', 1, 1])
#should %q({ :status => 1, :active => 1 })
#should %q(["complete=? and priority IN (?)", false, 1..3])
#should %q(['created_at > ?', 1.week.ago] )
#should %q(["title like :search or description like :search",{:search => "%Tiki%"}])
end #context
context "instance" do
  setup do
    @find_conditions = FindConditions.new
  end
  should "literals?" do
    assert @find_conditions.all_literals? 1
    assert @find_conditions.all_literals? 1, 2
    assert @find_conditions.all_literals? 'umur'
    a_node = build{ literal(1) }
    assert @find_conditions.some_nodes?( a_node )
    assert_equal false, @find_conditions.all_literals?(a_node)
  end
end

context "Conversion" do
  setup do
    @find_conditions = FindConditions.new
  end
  #ARITHMETIC
  should '+' do
    code = @find_conditions.convert_parse %q( value+1 = 2 )
    assert_pattern build{msg(msg(:_, '+', 1), '==', 2)}, code
  end
  should '-' do
    code = @find_conditions.convert_parse %q( value-1 = 0 )
    assert_pattern build{msg(msg(:_, '-', 1), '==', 0)}, code
  end
  should '-n' do
    code = @find_conditions.convert_parse %q( value = -1 )
    assert_pattern build{msg(:_, '==', -1)}, code
  end
  should '--n' do
    code = @find_conditions.convert_parse %q( value = --1 )
    assert_pattern build{msg(:_, '==', 1)}, code
  end
  should '+n' do
    code = @find_conditions.convert_parse %q( value = +1 )
    assert_pattern build{msg(:_, '==', 1) }, code
  end
  should '(n)' do
    code = @find_conditions.convert_parse %q( value = (((1))) )
    assert_pattern build{msg(:_, '==', 1) }, code
  end
  #STRING FUNCTION
  should 'lower' do
    code = @find_conditions.convert_parse %q( LOWER('UMUR') = 'umur' )
    assert true == code
  end
  should 'upper' do
    code = @find_conditions.convert_parse %q( UPPER('umur') = 'UMUR' )
    assert true == code
  end
  should 'concat' do
    code = @find_conditions.convert_parse %q( concat('u', 'mur') = 'umur' )
    assert_pattern build{ true  }, code
  end
  should '||' do
    code = @find_conditions.convert_parse %q( 'u' || 'mur' = 'umur' )
    assert_pattern build{ true  }, code
  end
  should '+ string' do
    code = @find_conditions.convert_parse %q( 'u' + 'mur' = 'umur' )
    assert true == code
  end
  #LITERAL
  should 'n' do
    code = @find_conditions.convert_parse %q( value = 123 )
    assert_pattern build{msg(:_, '==', 123) }, code
  end
  should 'n.n' do
    code = @find_conditions.convert_parse %q( value = 123.4 )
    assert_pattern build{msg(:_, '==', 123.4) }, code
  end
  should '1.1e10' do
    code = @find_conditions.convert_parse %q( value = 1.1e10 )
    assert_pattern build{msg(:_, '==', 1.1e10 ) }, code
  end
  should 'string' do
    code = @find_conditions.convert_parse %q( value = 'value' )
    assert_pattern build{msg(:_, '==', 'value' ) }, code
  end
  should 'date v' do
      code = @find_conditions.convert_parse %q( value = '1998-02-23T14:23:05' )      
      assert_pattern build{msg(:_, '==', :_)}, code
  end
  should 'do date'
  #REFERENCE
  should 'value' do
    code = @find_conditions.convert_parse %q( value = 1 )
    assert_pattern build{msg(sql_ref('value'), '==', 1) }, code
  end
  should 'Parent.value' do
    code = @find_conditions.convert_parse %q( Parent.value = 1 )
    assert_pattern build{msg(sql_ref('value', 'Parent'), '==', 1) }, code
  end
  
end #context

context "Reduction" do
  setup do
    @find_conditions = FindConditions.new
  end
  #boolean
  should 'or' do
    code = @find_conditions.convert_parse %q( 1=2 or 1=1 )
    assert true == code    
  end
  should 'v or' do
    code = @find_conditions.convert_parse %q( v=1 or p=2 )
    assert_pattern build{msg(:_, '||', :_)}, code
  end
  should 'v or true' do
    code = @find_conditions.convert_parse %q( v=1 or 1=1 )
    assert true == code
  end
  should 'not or' do
    code = @find_conditions.convert_parse %q(not( 1=2 or 1=1) )
    assert_pattern build{ false }, code    
  end
  should 'not v or' do
    code = @find_conditions.convert_parse %q(not( v=1 or p=2 ))
    assert_pattern build{msg(:_, '&&', :_)}, code
  end
  should 'and' do
    code = @find_conditions.convert_parse %q( 1=1 and 1=2 )
    assert_pattern build{ false }, code    
  end
  should '(bool)' do   
    code = @find_conditions.convert_parse %q( ((( 1=1 ))) )
    assert true == code    
  end
  should 'not(bool)' do   
    code = @find_conditions.convert_parse %q(not(((( 1123=1123 )))) )
    assert_pattern build{ false }, code    
  end
  should 'not bool' do
    code = @find_conditions.convert_parse %q(not 1 = 1 )
    assert false == code    
  end
  should 'not bool w paran' do
    code = @find_conditions.convert_parse %q(not(1 = 1) )
    assert false == code    
  end
  should 'not bool w space paran' do
    code = @find_conditions.convert_parse %q(not (1 = 1) )
    assert false == code    
  end
  should 'not and' do
    code = @find_conditions.convert_parse %q(not( 1=1 and 1=2) )
    assert true == code    
  end
  should 'v and' do
    code = @find_conditions.convert_parse %q( v = 1 and p = 2 )
    assert_pattern build{ msg(:_, '&&', :_) }, code    
  end
  should 'v and false' do
    code = @find_conditions.convert_parse %q( v=1 and 1=2 )
    assert_pattern build{ false }, code    
  end
  should 'not v and' do
    code = @find_conditions.convert_parse %q(not( v=1 and p=2) )
    assert_pattern build{ msg(:_, '||', :_) }, code    
  end
  should '(truth)' do
    code = @find_conditions.convert_parse %q( (1=1) )
    assert true == code
  end  

#comparison
  should '=' do
    code = @find_conditions.convert_parse %q( 1 = 1 )
    assert true == code    
  end
  should 'v =' do
    code = @find_conditions.convert_parse %q( v = 1 )
    assert_pattern build {msg(:_, '==', 1) }, code
  end
  should 'not v =' do
    code = @find_conditions.convert_parse %q( not v = 1 )
    assert_pattern build{ msg(:_, '!=', 1) }, code
  end
  should '!=' do
    code = @find_conditions.convert_parse %q( 1 != 1 )
    assert_pattern build{ false }, code    
  end
  should '<>' do
    code = @find_conditions.convert_parse %q( 1<>1 )
    assert_pattern build{ false }, code    
  end
  should 'v <>' do
    code = @find_conditions.convert_parse %q( value <> 1 )
    assert_pattern build{msg(:_, '!=', 1) }, code
  end
  should 'not <>' do
    code = @find_conditions.convert_parse %q(not 1<> 1 )
    assert true == code    
  end
  should 'not v <>' do
    code = @find_conditions.convert_parse %q(not v<> 1 )
    assert_pattern build{ msg(:_, '==', 1) }, code    
  end
  should '>' do
    code = @find_conditions.convert_parse %q( 2 > 1 )
    assert true == code    
  end
  should 'v  >' do
    code = @find_conditions.convert_parse %q( value > 2 )
    assert_pattern build{msg(:_, '>', 2) }, code
  end
  should 'not >' do
    code = @find_conditions.convert_parse %q( not 1 > 1 )
    assert true == code    
  end
  should 'not v >' do
    code = @find_conditions.convert_parse %q( not v > 1 )
    assert_pattern build{ msg(:_, '<=', 1) }, code    
  end
  should '>=' do
    code = @find_conditions.convert_parse %q( 1>=1 )
    assert true == code    
  end
  should 'v >=' do
    code = @find_conditions.convert_parse %q( v >= 2 )
    assert_pattern build{msg(:_, '>=', 2) }, code
  end
  should 'not >=' do
    code = @find_conditions.convert_parse %q( not 1>=2 )
    assert true == code    
  end
  should 'not v >=' do
    code = @find_conditions.convert_parse %q( not v>=2 )
    assert_pattern build{ msg(:_, '<', 2 ) }, code    
  end
  should '<' do
    code = @find_conditions.convert_parse %q( 1<2 )
    assert true == code    
  end
  should 'v <' do
    code = @find_conditions.convert_parse %q( value < 2 )
    assert_pattern build{msg(:_, '<', 2) }, code
  end
  should 'not <' do
    code = @find_conditions.convert_parse %q( not 1<1 )
    assert true == code    
  end
  should 'not v <' do
    code = @find_conditions.convert_parse %q( not v<1 )
    assert_pattern build{ msg(:_, '>=', 1) }, code    
  end
  should '<=' do
    code = @find_conditions.convert_parse %q( 1<=1 )
    assert true == code    
  end
  should 'not <=' do
    code = @find_conditions.convert_parse %q( not 2 <= 1 )
    assert true == code    
  end
  should 'not v <=' do
    code = @find_conditions.convert_parse %q( not v <= 1 )
    assert_pattern build{ msg(:_, '>', 1) }, code    
  end
#null
  should 'null' do
    code = @find_conditions.convert_parse %q( v is null )
    assert_pattern build{ msg(:_, 'nil?') }, code        
  end
#like
  should 'v like' do
    code = @find_conditions.convert_parse %q( v like '%mu%' )
    assert_pattern build{ msg(:_, '=~', /^.*mu.*$/) }, code    
  end
#in
  should 'in' do
    code = @find_conditions.convert_parse %q( v in (1, 2, 3) )
    assert_pattern build{ msg([1,2,3], 'include?', :_ )}, code    
  end
#between
  should 'between' do
    code = @find_conditions.convert_parse %q( v between 1 and 3 )
    assert_pattern build{ msg([1,2,3], 'include?', :_ )}, code    
  end
#function
  should 'v dowcase' do
    code = @find_conditions.convert_parse %q( LOWER('UMUR') = v )    
    assert_pattern build{msg('umur', '==', :_)},  code        
  end
  should 'downcase' do
    code = @find_conditions.convert_parse %q( LOWER('UMUR') = 'umur' )    
    assert true == code        
  end
  should '-1 = -(1+1/1-1)/1*1 ' do
    code = @find_conditions.convert_parse %q( -1 = -(1+1/1-1)/1*1 )
    assert true == code
  end
end #context

context "Optimizations" do
  setup do
    @find_conditions = FindConditions.new :klass_name=>'TestClass'
  end
  should "move columns left" do
    code = @find_conditions.convert_parse %q( 1 = id )
    assert_pattern build {msg(:_, '==', 1)}, code
  end
end

context "Reduction with klass_name" do
  setup do
    @find_conditions = FindConditions.new :klass_name=>'TestClass'
  end
  should "complete sql_ref" do
    code = @find_conditions.reduce( build {sql_ref('id')})
    assert_pattern build {sql_ref('id', 'TestClass')}, code
  end
  should "complete parsed sql_ref" do
    code = @find_conditions.convert_parse %q( id = 1 )
    assert_pattern build {msg(sql_ref('id', 'TestClass'), '==', 1)}, code
  end
end

context "Redundancy" do
  setup do
    @find_conditions = FindConditions.new :klass_name=>'TestClass'
  end
  should "case1" do
    source = build {msg(msg(sql_ref("id" ,"TestClass") ,"==" ,10) ,"&&" ,msg([10, 20] ,"include?" ,sql_ref("id" ,"TestClass")))}
    code = @find_conditions.reduce source
    assert_pattern build {msg([10] ,"include?" ,sql_ref("id" ,"TestClass"))}, code
  end
  should "case2" do
    source = build {msg(msg([10, 20] ,"include?" ,sql_ref("id" ,"TestClass")), '&&', msg(sql_ref("id" ,"TestClass") ,"==" ,10) )}
    code = @find_conditions.reduce source
    assert_pattern build {msg([10] ,"include?" ,sql_ref("id" ,"TestClass"))}, code
  end
  should "case3" do
    source = build {msg(msg([1, 2] ,"include?" ,sql_ref("id" ,"Klass")) ,"&&" ,msg([1, 2, 3] ,"include?" ,sql_ref("id" ,"Klass")))}
    code = @find_conditions.reduce source
    assert_pattern build {msg([1, 2] ,"include?" ,sql_ref("id" ,"Klass")) }, code    
  end
  should "case4" do
    source = build {msg(msg([1, 2, 3] ,"include?" ,sql_ref("id" ,"Klass")) ,"&&" ,msg([1, 2] ,"include?" ,sql_ref("id" ,"Klass")))}
    code = @find_conditions.reduce source
    assert_pattern build {msg([1, 2] ,"include?" ,sql_ref("id" ,"Klass")) }, code    
  end
  should "case5" do
    source = build {msg(msg(sql_ref("id" ,"TestClass") ,"==" ,10) ,"&&" ,msg([20, 30] ,"include?" ,sql_ref("id" ,"TestClass")))}
    code = @find_conditions.reduce source
    assert_pattern false, code    
  end
  should "distribution" do
    source = build {msg(msg(true, '||', msg(sql_ref("id" ,"TestClass") ,"==" ,10)) ,"&&" ,msg([20, 30] ,"include?" ,sql_ref("id" ,"TestClass")))}
    code = @find_conditions.reduce source
    assert_pattern build{msg([20, 30] ,"include?" ,sql_ref("id" ,"TestClass")) }, code        
  end
end

end #class FindConditionsTest

     end
    end
  end
end