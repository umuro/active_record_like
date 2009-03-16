require 'ConceptSpace::ActiveRecordLike::Adapter::OptionsHandler'.underscore
module ConceptSpace
  module ActiveRecordLike
    module Adapter
      

#NOTE. Use Object.send and attributes.keys
# to provide a active record class independent design

## attributes: Hash of object property values
## row ==nd attributes
## rows: Array of rows
## ids: Array of ids
## id: Any type of id to match a row

class SimpleAdapter 
  class << self

      def build &block
        PatternMatching::MatchExec::ExecuteAs::FuncNodeBuilder.new({}, self).instance_eval(&block)
      end
      
    def handler_klass
      ConceptSpace::ActiveRecordLike::Adapter::OptionsHandler
    end
    
    def count(klass_name, options=nil)
#      conditions = options && options[:conditions] 
      if options && !options.empty?
        #PLAN
        options_handler = handler_klass.new :klass_name=>klass_name, :primary_key=>primary_key(klass_name), :adapter=>self
        plan = options_handler.plan build{count(klass_name, options)}
        options_handler.eval plan
      else
        count_regardless(klass_name)
      end
    end

    def delete(klass_name, ids)
      if ids.kind_of? Array
        ids.inject(0) { |sum, id|
          sum + delete_one(klass_name, id)
        }
      else
        delete_one(klass_name, ids)
      end
    end

    def delete_all(klass_name, conditions = nil)    
      if conditions && ! conditions.empty?
         #PLAN
        options_handler = handler_klass.new :klass_name=>klass_name, :primary_key=>primary_key(klass_name), :adapter=>self
        plan = options_handler.plan build{delete_all(klass_name, conditions )   }
        options_handler.eval plan
      else
        delete_regardless(klass_name)
      end
    end

    ## Deletes all rows
    def delete_regardless(klass_name)
        all_keys_regardles(klass_name) do | id |
          delete_one(klass_name, id)
        end
    end

    def find_every(klass_name, options=nil)
#      conditions = options && options[:conditions]
      if options && !options.empty?
        #PLAN
        options_handler = handler_klass.new :klass_name=>klass_name, :primary_key=>primary_key(klass_name), :adapter=>self
        plan = options_handler.plan build{find_every(klass_name, options)}
        options_handler.eval plan
      else
        find_every_regardless(klass_name)
      end
    end

    ## Answers row with id
    def find_one_regarding(klass_name, id, options=nil)
        if options && !options.empty?
            options_handler = handler_klass.new :klass_name=>klass_name, :primary_key=>primary_key(klass_name), :adapter=>self
            plan = options_handler.plan build{find_one_regarding(klass_name, id, options)}
            options_handler.eval plan
        else
            find_one(klass_name, id)  
        end
    #PLAN
    end
    
    def find_initial(klass_name, options=nil)
      #PLAN
        options_handler = handler_klass.new :klass_name=>klass_name, :primary_key=>primary_key(klass_name), :adapter=>self
        plan = options_handler.plan build{find_initial(klass_name, options)}
        options_handler.eval plan
    end
    
    def find_last(klass_name, options=nil)
      #PLAN
        options_handler = handler_klass.new :klass_name=>klass_name, :primary_key=>primary_key(klass_name), :adapter=>self
        plan = options_handler.plan build{find_last(klass_name, options)}
        options_handler.eval plan
    end
      
    def find_some_regardless(klass_name, ids)
      ids.inject([]) {|rows, id|
        attributes = find_one(klass_name, id)
        rows << attributes if attributes
        rows
      }
    end

    def find_some(klass_name, ids, options = nil )
#      conditions = options && options[:conditions] 
       if options && !options.empty?
        #PLAN
        options_handler = handler_klass.new :klass_name=>klass_name, :primary_key=>primary_key(klass_name), :adapter=>self
        plan = options_handler.plan build{find_last(klass_name, options)}
        options_handler.eval plan
      else
        find_some_regardless(klass_name, ids)
      end
  end
  
    ## Abstract Methods
public    
    def primary_key(klass_name)
      'id'
    end
    
    ## Answers a collection of ids/keys
    def all_keys_regardless(klass_name)
      method_missing :all_keys_regardless
      #returns array
    end
    
    ## Creates a row
    ## Answers id
    def create(klass_name, attributes, id=nil)
      method_missing :create
      #returns id
    end

    ## Answers the count of all rows
    def count_regardless(klass_name)
      all_keys_regardless(klass_name).size
    end
    
    ## Deletes row with given id
    ## Answers 0 or 1
    def delete_one(klass_name, id)
      method_missing :delete
    end
    
    ## Answers all rows
    def find_every_regardless(klass_name)
      method_missing :find_every_regardles
      #returns array
    end

    ## Answers row with id
    def find_one(klass_name, id)
      method_missing :find_one
      #returns attributes or nil
    end

     ## Automatic key generator if necessary
     #not called if there is an id in row (optional)
    def new_key #optional if manual keys are provided
      method_missing :new_key      
      #returns key
    end

    ## Answers boolean. True if successful
    def update(klass_name, id, attributes)
      method_missing :update
    end
  
 protected    
     #not called if there is an id (optional)
    def all_keys_add(klass_name, key)
      throw :key_cannot_be_nil unless key
      method_missing :all_keys_add            
    end

    def all_keys_remove(klass_name, key)
      throw :key_cannot_be_nil unless key
      method_missing :all_keys_remove            
    end
  end
end

    end
  end
end
