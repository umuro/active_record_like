#TODO Go over base. Some methods might be unnecessary and already handled by active_record

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
    def table_name
      self.name
    end
    
    #TODO http://api.rubyonrails.org/classes/ActiveRecord/Calculations/ClassMethods.html#M002130
    def count(*args)
     column, options =  construct_count_options_from_args(*args)
      throw :unsupported unless column == :all
      adapter.count(self.name, cs_sanitize_options(options))
    end

    def delete_all(conditions = nil)
      adapter.delete_all(self.name , conditions)
    end
    
    #TODO check exists?(id_or_conditions)
 
    def cs_sanitize_options(options)
      return unless options
      if options[:conditions]
        options_s = options.dup
        options_s[:conditions] = sanitize_sql_for_conditions(options[:conditions]) 
      else
        options_s = options
      end
      options_s
    end
    protected :cs_sanitize_options

     #TODO Go over find http://api.rubyonrails.org/classes/ActiveRecord/Base.html#M002220
    def find_every(options)
      include_associations = merge_includes(scope(:find, :include), options[:include])
      adapter_options = options.dup
      adapter_options.delete :include
      adapter_options.delete :readonly

      rows = adapter.find_every(self.name, cs_sanitize_options(adapter_options))
      records = rows.collect! { |record| instantiate(record) }

        if include_associations.any?
          preload_associations(records, include_associations)
        end
      
      records.each { |record| record.readonly! } if options[:readonly]
      
      records
    end

    def find_every(options)
      rows = adapter.find_every(self.name, cs_sanitize_options(options))
      rows.collect! { |record| instantiate(record) }
    end
    def find_initial(options)
      record = adapter.find_initial(self.name, cs_sanitize_options(options))
      instantiate(record)
    end
    def find_last(options)
      record = adapter.find_last(self.name, cs_sanitize_options(options))
      instantiate(record)
    end
    def find_some(ids, options)
      rows = adapter.find_some(self.name, ids, cs_sanitize_options(options))        
      rows.collect! { |record| instantiate(record) }
    end
    def find_one(id, options)
      record = adapter.find_one_regarding(self.name, id, cs_sanitize_options(options))                
      instantiate(record) if record
    end

    def exists?(id_or_conditions)
      case id_or_conditions
        when Array, Hash then not find_initial(id_or_conditions).nil?
        else not find_one(id_or_conditions).nil?
      end       
    end

    def delete(id_or_array)
      adapter.delete(self.name, id_or_array)
    end
  end #end of class

  def create_without_callbacks
    new_id_or_nil = adapter.create(self.class.name, self.attributes) if super
    self.id = new_id_or_nil if new_id_or_nil 
    @new_record = false
    new_id_or_nil
  end

  def update_without_callbacks
    adapter.update(self.class.name, self.id, self.attributes) if super
  end
  
  def destroy_without_callbacks
    if super
      adapter.delete_one(self.class.name, self.id) 
      self
    end
  end

end

  end
end