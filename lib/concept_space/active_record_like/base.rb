module ConceptSpace
  module ActiveRecordLike

class Base < ActiveRecord::BaseWithoutTable
  class << self
#    attr_accessor :adapter
    def adapter(an_adapter = nil)
      if an_adapter
        @@adapter = an_adapter
      else
        @@adapter        
      end
    end
  end #end of class
  
  def adapter
    self.class.adapter
  end
  
  class << self
    def count(conditions)
      adapter.count(conditions)
    end
    def find_every(conditions)
      rows = adapter.find_every(self.name, conditions)
      rows.collect! { |record| instantiate(record) }
    end
    def find_initial(conditions)
      record = adapter.find_initial(self.name, conditions)
      instantiate(record)
    end
    def find_last(conditions)
      record = adapter.find_last(self.name, conditions)
      instantiate(record)
    end
    def find_some(conditions)
      rows = adapter.find_some(self.name, conditions)
      rows.collect! { |record| instantiate(record) }
    end
    def find_one(conditions)
      record = adapter.find_one(self.name, conditions)
      instantiate(record)
    end
    def delete(id)
      adapter.delete_one(self.name, id)
    end
  end #end of class

  def create_without_callbacks
    new_id_or_nil = adapter.create(self.class.name, self.attributes) if super
    
    if new_id_or_nil 
      self.id = new_id_or_nil
      #check_it = self.id
     # 1
    end

    #self.id = new_id_or_nil unless new_id_or_nil
    @new_record = false
    new_id_or_nil
  end
  def update_without_callbacks
    adapter.update(self.class.name, self.id, self.attributes) if super
  end
  def destroy_without_callbacks
    if super
      answer = adapter.delete_one(self.class.name, self.id) 
      if answer == 1 
        self
      end
    end
  end
end

  end
end