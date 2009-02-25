module ConceptSpace
  module ActiveRecordLike
    module Adapter
      

#NOTE. Use Object.send and attributes.keys
# to provide a active record class independent design

## attributes: Hash of object property values
## row == attributes
## rows: Array of rows
## ids: Array of ids
## id: Any type of id to match a row

#DEBUG

class SimpleAdapter 
  class << self
    
    def count(klass_name, conditions={})
      unless conditions.empty?
        filter(find_every_regardles(klass_name), conditions).size
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

    def delete_all(klass_name, conditions = {})    
      unless conditions.empty?
        filter(find_every_regardles(klass_name), conditions) do | r |
          r.destroy
        end
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

    
    def find_every(klass_name, conditions={})
      unless conditions.empty?
        filter(find_every_regardles(klass_name), conditions)
      else
        find_every_regardless(klass_name)
      end
    end

    def find_initial(klass_name, conditions={})
      find_every(klass_name, conditions).first
    end
    
    def find_last(klass_name, conditions={})
      find_every(klass_name, conditions).last
    end
    
    def find_some(klass_name, ids)
      ids.inject([]) {|rows, id|
        attributes = find_one(klass_name, id)
        rows << attributes if attributes
        rows
      }
    end
    
    ## Abstract Methods
    
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
      method_missing :count_regardless
      #returns integer
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
