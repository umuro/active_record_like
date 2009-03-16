require 'test_helper'
#require 'patternmatching' 
##include PatternMatching

require 'ConceptSpace::ActiveRecordLike::Adapter::OptionsHandler'.underscore

module ConceptSpace
  module ActiveRecordLike
    module Adapter
      
## The idea is to reduce the calls to basic building block calls:      
#      all_keys_regardless
#      count_regardless
#      delete
#      delete_one
#      delete_regardless
#      all_keys_regardless
#      find_every_regardless
#      find_one
#      find_some_regardless

class OptionsHandlerTest < NoFixtureTestCase

  context "OptionsHandler" do
    setup do
      set_stub = [{'id'=>1, 'price'=>10, 'name'=>'name1', 'description'=>'d1'},{'id'=>1, 'price'=>20} ]
      adapter = stub :count_regardless=>0, 
        :delete_regardless=>nil, 
        :delete=>nil, 
        :delete_one=>nil,  
        :find_one=>set_stub[0], 
        :find_every_regardless=>set_stub, 
        :find_some_regardless=>set_stub
      @handler = OptionsHandler.new(:klass_name=>'Klass', :primary_key=>'id', :adapter=>adapter)
    end
      context "delete_all" do
        should "nil" do
          code = @handler.plan( build{delete_all('Klass', nil)} )
          assert_pattern build{adapter('delete_regardless','Klass')}, code
         @handler.eval code
        end
        should "no string" do
          code = @handler.plan( build{delete_all('Klass', "")} )
          assert_pattern build{adapter('delete_regardless','Klass')}, code
         @handler.eval code
        end
        should "id = 10" do                     #MUST Completing table name
          code = @handler.plan( build{delete_all('Klass', "id = 10")} )
          assert_pattern build{adapter('delete_one','Klass', 10)}, code
         @handler.eval code
        end
        should "Klass.id = 10" do                  #MUST Referring table name
          code = @handler.plan( build{delete_all('Klass', "Klass.id = 10")} )
          assert_pattern build{adapter('delete_one','Klass', 10)}, code
         @handler.eval code
       end
        should "OtherKlass.id = 10" do          #Wrong reference
          code = @handler.plan( build{delete_all('Klass', "OtherKlass.id = 10")} )
          assert_pattern build{fn("set_each_delete", 'Klass', fn("set_select" ,adapter("find_every_regardless" ,"Klass") ,msg(sql_ref("id" ,"OtherKlass") ,"==" ,10)))}, code
         assert_raises(RuntimeError){ @handler.eval code }
       end
        should "id in (1,2,3)" do                    #Optimization
          code = @handler.plan( build{delete_all('Klass', "id in (1,2,3)")} )
          assert_pattern build{adapter('delete','Klass', [1,2,3])}, code
         @handler.eval code
       end
        should "id = 10 or id = 20" do          #Optimization 
          code = @handler.plan( build{delete_all('Klass', "id = 10 or id = 20")} )
          assert_pattern build{adapter('delete','Klass', [20,10])}, code
         @handler.eval code
       end
        should "price = 10 or id = 20" do          #Optimization
          code = @handler.plan( build{delete_all('Klass', "price = 10 or id = 20")} )
          assert_pattern_fail build{adapter('delete','Klass', [20,10])}, code
         @handler.eval code
       end
        should "id = 10 or id = 20 or id = 30" do          #Optimization
          code = @handler.plan( build{delete_all('Klass', "id = 10 or id = 20 or id = 30")} )
          assert_pattern build{adapter('delete','Klass', [30,20,10])}, code
         @handler.eval code
       end
        should "id = 10 and id = 20" do        #Noop
          code = @handler.plan( build{delete_all('Klass', "id = 10 and id = 20")} )
          assert_pattern '', code
         @handler.eval code
       end
        should "id = 10 and price >20" do   #Extracting
          code = @handler.plan( build{delete_all('Klass', 'id = 10 and price >20')} )
          assert_pattern build{fn("set_each_delete", 'Klass', fn("set_select" ,adapter("find_some_regardless" ,"Klass" ,[10]) ,msg(sql_ref("price" ,"Klass") ,">" ,20)))}, code
         @handler.eval code
      end
        should "price >20 and id = 10" do    #Extracting later
          code = @handler.plan( build{delete_all('Klass', 'id = 10 and price >20')} )
          assert_pattern build{fn("set_each_delete", 'Klass', fn("set_select" ,adapter("find_some_regardless" ,"Klass" ,[10]) ,msg(sql_ref("price" ,"Klass") ,">" ,20)))}, code
         @handler.eval code
      end
        should "id >10"                          #Using keys first
        should "LOWER(name) LIKE '%search%' or LOWER(description) LIKE '%search%'" do #MUST
          code = @handler.plan( build{delete_all('Klass', "LOWER(name) LIKE '%search%' or LOWER(description) LIKE '%search%'")} )
          assert_pattern build{fn("set_each_delete", 'Klass', fn("set_select" ,adapter("find_every_regardless" ,"Klass") ,msg(msg(msg(sql_ref("name" ,"Klass") ,"downcase") ,"=~" ,"^.*search.*$") ,"||" ,msg(msg(sql_ref("description" ,"Klass") ,"downcase") ,"=~" ,"^.*search.*$"))))}, code
         @handler.eval code
       end
     end #delete_all
      context "count" do
        should "nil" do
          code = @handler.plan( build{count('Klass', nil)} )
          assert_pattern build{adapter('count_regardless','Klass')}, code
         @handler.eval code
        end
        should "no string" do
          code = @handler.plan( build{count('Klass', :conditions=>"")} )
          assert_pattern build{adapter('count_regardless','Klass')}, code
         @handler.eval code
        end
        should "id = 10" do                     #MUST Completing table name
          code = @handler.plan( build{count('Klass',  :conditions=>"id = 10")} )
          assert_pattern build{fn('set_size', adapter('find_some_regardless','Klass', [10]))}, code
         @handler.eval code
        end
        should "Klass.id = 10" do                  #MUST Referring table name
          code = @handler.plan( build{count('Klass', :conditions=>"Klass.id = 10")} )
          assert_pattern build{fn('set_size', adapter('find_some_regardless','Klass', [10]))}, code
         @handler.eval code
       end
        should "OtherKlass.id = 10" do          #Wrong reference
          code = @handler.plan( build{count('Klass', :conditions=>"OtherKlass.id = 10")} )
          assert_pattern_fail build{fn('set_size', adapter('find_some_regardless','Klass', [10]))}, code
         assert_raises(RuntimeError){ @handler.eval code }
       end
        should "id in (1,2,3)" do                    #Optimization
          code = @handler.plan( build{count('Klass', :conditions=>"id in (1,2,3)")} )
          assert_pattern build{fn('set_size', adapter('find_some_regardless','Klass', [1,2,3]))}, code
         @handler.eval code
       end
        should "id = 10 or id = 20" do          #Optimization
          code = @handler.plan( build{count('Klass', :conditions=>"id = 10 or id = 20")} )
          assert_pattern build{fn('set_size', adapter('find_some_regardless','Klass', [20,10]))}, code
         @handler.eval code
       end
        should "price = 10 or id = 20" do          #Optimization
          code = @handler.plan( build{count('Klass', :conditions=>"price = 10 or id = 20")} )
          assert_pattern_fail build{fn('set_size', adapter('find_some_regardless','Klass', [20,10]))}, code
         @handler.eval code
       end
        should "id = 10 or id = 20 or id = 30" do          #Optimization
          code = @handler.plan( build{count('Klass', :conditions=>"id = 10 or id = 20 or id = 30")} )
          assert_pattern build{fn('set_size', adapter('find_some_regardless','Klass', [30,20,10]))}, code
         @handler.eval code
       end
        should "id = 10 and id = 20" do        #Noop
          code = @handler.plan( build{count('Klass', :conditions=>"id = 10 and id = 20")} )
          assert_pattern 0, code
         @handler.eval code
       end
        should "id = 10 and price >20" do   #Extracting
          code = @handler.plan( build{count('Klass', :conditions=>'id = 10 and price >20')} )
          assert_pattern build{fn("set_size" ,fn("set_select" ,adapter("find_some_regardless" ,"Klass" ,[10]) ,msg(sql_ref("price" ,"Klass") ,">" ,20)))}, code
         @handler.eval code
      end
        should "price >20 and id = 10" do    #Extracting later
          code = @handler.plan( build{count('Klass', :conditions=>'id = 10 and price >20')} )
          assert_pattern build{fn("set_size" ,fn("set_select" ,adapter("find_some_regardless" ,"Klass" ,[10]) ,msg(sql_ref("price" ,"Klass") ,">" ,20)))}, code
         @handler.eval code
      end
        should "id >10"                          #Using keys first
        should "LOWER(name) LIKE '%search%' or LOWER(description) LIKE '%search%'" do #MUST
          code = @handler.plan( build{count('Klass', :conditions=>"LOWER(name) LIKE '%search%' or LOWER(description) LIKE '%search%'")} )
          assert_pattern build{fn("set_size" ,fn("set_select" ,adapter("find_every_regardless" ,"Klass") ,msg(msg(msg(sql_ref("name" ,"Klass") ,"downcase") ,"=~" ,"^.*search.*$") ,"||" ,msg(msg(sql_ref("description" ,"Klass") ,"downcase") ,"=~" ,"^.*search.*$"))))}, code
         @handler.eval code
       end        
     end #count

      context "find_every" do
        should "nil" do
          code = @handler.plan( build{find_every('Klass', nil)} )
          assert_pattern build{adapter('find_every_regardless','Klass')}, code
         @handler.eval code
        end
        should "no string" do
          code = @handler.plan( build{find_every('Klass', :conditions=>"")} )
          assert_pattern build{adapter('find_every_regardless','Klass')}, code
         @handler.eval code
        end
        should "id = 10" do                     #MUST Completing table name
          code = @handler.plan( build{find_every('Klass',  :conditions=>"id = 10")} )
          assert_pattern build{adapter('find_some_regardless','Klass', [10])}, code
         @handler.eval code
        end
        should "Klass.id = 10" do                  #MUST Referring table name
          code = @handler.plan( build{find_every('Klass', :conditions=>"Klass.id = 10")} )
          assert_pattern build{adapter('find_some_regardless','Klass', [10])}, code
         @handler.eval code
       end
        should "OtherKlass.id = 10" do          #Wrong reference
          code = @handler.plan( build{find_every('Klass', :conditions=>"OtherKlass.id = 10")} )
          assert_pattern_fail build{adapter('find_some_regardless','Klass', [10])}, code
         assert_raises(RuntimeError){ @handler.eval code }
       end
        should "id in (1,2,3)" do                    #Optimization
          code = @handler.plan( build{find_every('Klass', :conditions=>"id in (1,2,3)")} )
          assert_pattern build{adapter('find_some_regardless','Klass', [1,2,3])}, code
         @handler.eval code
       end
        should "id = 10 or id = 20" do          #Optimization
          code = @handler.plan( build{find_every('Klass', :conditions=>"id = 10 or id = 20")} )
          assert_pattern build{ adapter('find_some_regardless','Klass', [20,10])}, code
         @handler.eval code
       end
        should "price = 10 or id = 20" do          #Optimization
          code = @handler.plan( build{find_every('Klass', :conditions=>"price = 10 or id = 20")} )
          assert_pattern_fail build{adapter('find_some_regardless','Klass', [20,10])}, code
         @handler.eval code
       end
        should "id = 10 or id = 20 or id = 30" do          #Optimization
          code = @handler.plan( build{find_every('Klass', :conditions=>"id = 10 or id = 20 or id = 30")} )
          assert_pattern build{adapter('find_some_regardless','Klass', [30,20,10])}, code
         @handler.eval code
       end
        should "id = 10 and id = 20" do        #Noop
          code = @handler.plan( build{find_every('Klass', :conditions=>"id = 10 and id = 20")} )
          assert_pattern [], code
         @handler.eval code
       end
        should "id = 10 and price >20" do   #Extracting
          code = @handler.plan( build{find_every('Klass', :conditions=>'id = 10 and price >20')} )
          assert_pattern build{fn("set_select" ,adapter("find_some_regardless" ,"Klass" ,[10]) ,msg(sql_ref("price" ,"Klass") ,">" ,20))}, code
         @handler.eval code
      end
        should "price >20 and id = 10" do    #Extracting later
          code = @handler.plan( build{find_every('Klass', :conditions=>'id = 10 and price >20')} )
          assert_pattern build{fn("set_select" ,adapter("find_some_regardless" ,"Klass" ,[10]) ,msg(sql_ref("price" ,"Klass") ,">" ,20))}, code
         @handler.eval code
      end
       should "id >10"                          #Using keys first
       should "LOWER(name) LIKE '%search%' or LOWER(description) LIKE '%search%'" do #MUST
          code = @handler.plan( build{find_every('Klass', :conditions=>"LOWER(name) LIKE '%search%' or LOWER(description) LIKE '%search%'")} )
          assert_pattern build{fn("set_select" ,adapter("find_every_regardless" ,"Klass") ,msg(msg(msg(sql_ref("name" ,"Klass") ,"downcase") ,"=~" ,"^.*search.*$") ,"||" ,msg(msg(sql_ref("description" ,"Klass") ,"downcase") ,"=~" ,"^.*search.*$")))}, code
         @handler.eval code
      end   
       should "order" do
          code = @handler.plan( build{find_every('Klass', :order=>%q(Parent."price" ASC), :conditions=>'price >20')} )
          assert_pattern build {fn( 'set_order', :_, sql_sort_order(:_,  :_ ) )}, code
         @handler.eval code
      end
        should "offset_limit" do
          code = @handler.plan( build{find_every('Klass', :offset=>2, :limit=>1)} )
          assert_pattern build{fn('set_offset_limit', adapter('find_every_regardless','Klass'), [2, 1])}, code
         @handler.eval code
        end
     end #find_every

      context "find_some"  do
        should "nil" do
          code = @handler.plan( build{find_some('Klass', [1], nil)} )
          assert_pattern build{adapter('find_some_regardless','Klass', [1])}, code
         @handler.eval code
        end
        should "no string" do
          code = @handler.plan( build{find_some('Klass', [1], :conditions=>"")} )
          assert_pattern build{adapter('find_some_regardless','Klass', [1])}, code
         @handler.eval code
        end
        should "id = 10" do                     #MUST Completing table name
          code = @handler.plan( build{find_some('Klass',  [10], :conditions=>"id = 10")} )
          assert_pattern build{adapter('find_some_regardless','Klass', [10])}, code
         @handler.eval code
        end
        should "Klass.id = 10" do                  #MUST Referring table name
          code = @handler.plan( build{find_some('Klass', [10], :conditions=>"Klass.id = 10")} )
          assert_pattern build{adapter('find_some_regardless','Klass', [10])}, code
         @handler.eval code
       end
        should "OtherKlass.id = 10" do          #Wrong reference
          code = @handler.plan( build{find_some('Klass', [10], :conditions=>"OtherKlass.id = 10")} )
          assert_pattern_fail build{adapter('find_some_regardless','Klass', [10])}, code
         assert_raises(RuntimeError){ @handler.eval code }
       end
        should "id in (1,2,3)" do                    #Optimization
          code = @handler.plan( build{find_some('Klass', [1,2,3], :conditions=>"id in (1,2,3)")} )
          assert_pattern build{adapter('find_some_regardless','Klass', [1,2,3])}, code
         @handler.eval code
       end
        should "id = 10 or id = 20" do          #Optimization
          code = @handler.plan( build{find_some('Klass', [20, 10], :conditions=>"id = 10 or id = 20")} )
          assert_pattern build{ adapter('find_some_regardless','Klass', [20,10])}, code
         @handler.eval code
       end
        should "price = 10 or id = 20" do          #Optimization
          code = @handler.plan( build{find_some('Klass', [10,20], :conditions=>"price = 10 or id = 20")} )
          assert_pattern_fail build{adapter('find_some_regardless','Klass', [20,10])}, code
         @handler.eval code
       end
        should "id = 10 or id = 20 or id = 30" do          #Optimization
          code = @handler.plan( build{find_some('Klass', [10,20], :conditions=>"id = 10 or id = 20 or id = 30")} )
          assert_pattern build{adapter('find_some_regardless','Klass', [20,10])}, code
         @handler.eval code
       end
        should "id = 10 and id = 20" do        #Noop
          code = @handler.plan( build{find_some('Klass', [10], :conditions=>"id = 10 and id = 20")} )
          assert_pattern [], code
         @handler.eval code
       end
        should "id = 10 and price >20" do   #Extracting
          code = @handler.plan( build{find_some('Klass', [10], :conditions=>'id = 10 and price >20')} )
          assert_pattern build{fn("set_select" ,adapter("find_some_regardless" ,"Klass" ,[10]) ,msg(sql_ref("price" ,"Klass") ,">" ,20))}, code
         @handler.eval code
      end
        should "price >20 and id = 10" do    #Extracting later
          code = @handler.plan( build{find_some('Klass', [10], :conditions=>'id = 10 and price >20')} )
          assert_pattern build{fn("set_select" ,adapter("find_some_regardless" ,"Klass" ,[10]) ,msg(sql_ref("price" ,"Klass") ,">" ,20))}, code
         @handler.eval code
      end
        should "id >10"                          #Using keys first
        should "LOWER(name) LIKE '%search%' or LOWER(description) LIKE '%search%'"  #MUST
#        should "LOWER(name) LIKE '%search%' or LOWER(description) LIKE '%search%'" do #MUST
#          code = @handler.plan( build{find_some('Klass', [10], :conditions=>"LOWER(name) LIKE '%search%' or LOWER(description) LIKE '%search%'")} )
#          assert_pattern build{fn("set_select" ,adapter("find_some_regardless" ,"Klass") ,msg(msg(msg(sql_ref("name" ,"Klass") ,"downcase") ,"=~" ,"^.*search.*$") ,"||" ,msg(msg(sql_ref("description" ,"Klass") ,"downcase") ,"=~" ,"^.*search.*$")))}, code
#       end                
     end #find_some

      context "find_one"  do
        should "nil" do
          code = @handler.plan( build{find_one_regarding('Klass', 1, nil)} )
          assert_pattern build{adapter('find_one','Klass', 1)}, code
         @handler.eval code
        end
        should "no string" do
          code = @handler.plan( build{find_one_regarding('Klass', 1, :conditions=>"")} )
          assert_pattern build{adapter('find_one','Klass', 1)}, code
         @handler.eval code
        end
        should "id = 1" do                     #MUST Completing table name
          code = @handler.plan( build{find_one_regarding('Klass',  1, :conditions=>"id = 1")} )
          assert_pattern build{adapter('find_one','Klass', 1)}, code
         @handler.eval code
        end
        should "Klass.id = 1" do                  #MUST Referring table name
          code = @handler.plan( build{find_one_regarding('Klass', 1, :conditions=>"Klass.id = 1")} )
          assert_pattern build{adapter('find_one','Klass', 1)}, code
         @handler.eval code
       end
        should "OtherKlass.id = 10" do          #Wrong reference
          code = @handler.plan( build{find_one_regarding('Klass', 10, :conditions=>"OtherKlass.id = 10")} )
          assert_pattern_fail build{adapter('find_one','Klass', 10)}, code
         assert_raises(RuntimeError){ @handler.eval code }
       end
        should "id in (1,2,3)" do                    #Optimization
          code = @handler.plan( build{find_one_regarding('Klass', 1, :conditions=>"id in (1,2,3)")} )
          assert_pattern build{adapter('find_one','Klass', 1)}, code
         @handler.eval code
       end
        should "id = 10 or id = 20" do          #Optimization
          code = @handler.plan( build{find_one_regarding('Klass', 10, :conditions=>"id = 10 or id = 20")} )
          assert_pattern build{ adapter('find_one','Klass', 10)}, code
         @handler.eval code
       end
        should "price = 10 or id = 20" do          #Optimization
          code = @handler.plan( build{find_one_regarding('Klass', 10, :conditions=>"price = 10 or id = 20")} )
          assert_pattern_fail build{adapter('find_one','Klass',10)}, code
         @handler.eval code
       end
        should "id = 10 or id = 20 or id = 30" do          #Optimization
          code = @handler.plan( build{find_one_regarding('Klass', 10, :conditions=>"id = 10 or id = 20 or id = 30")} )
          assert_pattern build{adapter('find_one','Klass', 10)}, code
         @handler.eval code
       end
        should "id = 10 and id = 20" do        #Noop
          code = @handler.plan( build{find_one_regarding('Klass', 10, :conditions=>"id = 10 and id = 20")} )
          assert_pattern nil, code
         @handler.eval code
       end
        should "id = 10 and price >20" do   #Extracting
          code = @handler.plan( build{find_one_regarding('Klass', 10, :conditions=>'id = 10 and price >20')} )
          assert_pattern build{fn('set_first', fn("set_select" ,adapter("find_some_regardless" ,"Klass" ,[10]) ,msg(sql_ref("price" ,"Klass") ,">" ,20)))}, code
         @handler.eval code
      end
        should "price >20 and id = 10" do    #Extracting later
          code = @handler.plan( build{find_one_regarding('Klass', 10, :conditions=>'id = 10 and price >20')} )
          assert_pattern build{fn('set_first', fn("set_select" ,adapter("find_some_regardless" ,"Klass" ,[10]) ,msg(sql_ref("price" ,"Klass") ,">" ,20)))}, code
         @handler.eval code
      end
        should "id >10"                          #Using keys first
        should "LOWER(name) LIKE '%search%' or LOWER(description) LIKE '%search%'" #MUST
#        should "LOWER(name) LIKE '%search%' or LOWER(description) LIKE '%search%'" do #MUST
#          code = @handler.plan( build{find_one_regarding('Klass', 10, :conditions=>"LOWER(name) LIKE '%search%' or LOWER(description) LIKE '%search%'")} )
#          assert_pattern build{fn("set_select" ,adapter("find_one" ,"Klass") ,msg(msg(msg(sql_ref("name" ,"Klass") ,"downcase") ,"=~" ,"^.*search.*$") ,"||" ,msg(msg(sql_ref("description" ,"Klass") ,"downcase") ,"=~" ,"^.*search.*$")))}, code
#       end                
     end #find_one
      context "find initial" do
        should "nil" do
          code = @handler.plan( build{find_initial('Klass', nil)} )
          assert_pattern build{fn('set_first', adapter('find_every_regardless','Klass'))}, code
         @handler.eval code
        end
        should "no string" do
          code = @handler.plan( build{find_initial('Klass', :conditions=>"")} )
          assert_pattern build{fn('set_first', adapter('find_every_regardless','Klass'))}, code
         @handler.eval code
        end
        should "id = 10" do                     #MUST Completing table name
          code = @handler.plan( build{find_initial('Klass',  :conditions=>"id = 10")} )
          assert_pattern build{adapter('find_one','Klass', 10)}, code
        end
        should "Klass.id = 10" do                  #MUST Referring table name
          code = @handler.plan( build{find_initial('Klass', :conditions=>"Klass.id = 10")} )
          assert_pattern build{adapter('find_one','Klass', 10)}, code
         @handler.eval code
       end
        should "OtherKlass.id = 10" do          #Wrong reference
          code = @handler.plan( build{find_initial('Klass', :conditions=>"OtherKlass.id = 10")} )
          assert_pattern_fail build{adapter('find_one','Klass', 10)}, code
         assert_raises(RuntimeError){ @handler.eval code }
       end
        should "id in (1,2,3)" do                    #Optimization
          code = @handler.plan( build{find_initial('Klass', :conditions=>"id in (1,2,3)")} )
          assert_pattern build{adapter("find_one" ,"Klass" ,1)}, code
         @handler.eval code
       end
        should "id = 10 or id = 20" do          #Optimization
          code = @handler.plan( build{find_initial('Klass', :conditions=>"id = 10 or id = 20")} )
          assert_pattern build{adapter("find_one" ,"Klass" ,20)}, code
         @handler.eval code
       end
        should "price = 10 or id = 20" do          #Optimization
          code = @handler.plan( build{find_initial('Klass', :conditions=>"price = 10 or id = 20")} )
          assert_pattern_fail build{fn('set_first', adapter('find_some_regardless','Klass', [20,10]))}, code
         @handler.eval code
       end
     end #find_initial
      context "find last" do
        should "nil" do
          code = @handler.plan( build{find_last('Klass', nil)} )
          assert_pattern build{fn('set_last', adapter('find_every_regardless','Klass'))}, code
         @handler.eval code
        end
        should "no string" do
          code = @handler.plan( build{find_last('Klass', :conditions=>"")} )
          assert_pattern build{fn('set_last', adapter('find_every_regardless','Klass'))}, code
         @handler.eval code
        end
        should "id = 10" do                     #MUST Completing table name
          code = @handler.plan( build{find_last('Klass',  :conditions=>"id = 10")} )
          assert_pattern build{adapter('find_one','Klass', 10)}, code
         @handler.eval code
        end
        should "Klass.id = 10" do                  #MUST Referring table name
          code = @handler.plan( build{find_last('Klass', :conditions=>"Klass.id = 10")} )
          assert_pattern build{adapter('find_one','Klass', 10)}, code
         @handler.eval code
       end
        should "OtherKlass.id = 10" do          #Wrong reference
          code = @handler.plan( build{find_last('Klass', :conditions=>"OtherKlass.id = 10")} )
          assert_pattern_fail build{adapter('find_one','Klass', 10)}, code
         assert_raises(RuntimeError){ @handler.eval code }
       end
        should "id in (1,2,3)" do                    #Optimization
          code = @handler.plan( build{find_last('Klass', :conditions=>"id in (1,2,3)")} )
          assert_pattern build{adapter("find_one" ,"Klass" ,1)}, code
         @handler.eval code
       end
        should "id = 10 or id = 20" do          #Optimization
          code = @handler.plan( build{find_last('Klass', :conditions=>"id = 10 or id = 20")} )
          assert_pattern build{adapter("find_one" ,"Klass" ,20)}, code
         @handler.eval code
       end
        should "price = 10 or id = 20" do          #Optimization
          code = @handler.plan( build{find_last('Klass', :conditions=>"price = 10 or id = 20")} )
          assert_pattern_fail build{fn('set_last', adapter('find_some_regardless','Klass', [20,10]))}, code
         @handler.eval code
       end
     end
  end #context OptionsHandler
end #class OptionsHandlerTest

    end
  end
end