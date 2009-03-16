puts "Loading CacheAdapter" if RAILS_ENV=='test'

require 'concept_space/active_record_like/adapter/simple_adapter'
require 'fileutils'

module ConceptSpace
  module ActiveRecordLike
    module Adapter

class CacheAdapter < SimpleAdapter
  class << self
    
    def all_keys_regardless(klass_name)
      coll_key = as_key(klass_name, 'all')
      Rails.cache.fetch(coll_key) {[]}
    end

    def as_key(klass_name, id)
      "#{klass_name}/#{id}"      
    end

    def count_regardless(klass_name)
        all_keys_regardless(klass_name).size      
    end

    def create(klass_name, attributes)
          unless attributes['id']
            id = self.new_key(klass_name)
            #attributes[:id] = id
          else
            id = attributes[primary_key(klass_name)]
          end
#puts "WRITE(create) ID: #{id}" if RAILS_ENV == 'test'
          Rails.cache.write(id,attributes)   
          all_keys_add(klass_name, id)
          id
    end
    
    def delete_one(klass_name, id)
      if Rails.cache.delete( id )
        all_keys_remove(klass_name, id)
        1
      else
        0
      end
    end

    def delete_regardless(klass_name)
      coll_key = as_key(klass_name, 'all')
      Rails.cache.write(coll_key, [])          
    end
        
    def find_every_regardless(klass_name)
      all_keys_regardless(klass_name).collect { |id| 
        find_one(klass_name, id)
      }   
    end
    
    def find_one(klass_name, id)
#puts "FETCH ID: #{id}" if RAILS_ENV == 'test'      
      attributes = Rails.cache.fetch(id)
      if attributes
        attributes = attributes.dup  #unfreeze
        attributes[primary_key(klass_name)]=id
      end
      attributes
    end
    
    def update(klass_name, id, attributes)
      a = attributes.dup
      a.delete primary_key(klass_name)
#puts "WRITE(update) #{id}"      if RAILS_ENV == 'test'      
      Rails.cache.write(id, a)
    end

    def new_key(klass_name)
      as_key(klass_name, uuid_generator.generate)
    end

    attr_reader :uuid_generator
    def uuid_generator

      begin
        @uuid_generator ||= (
        home = ENV['HOME']
        uuid_file = File.join(home, '.ruby-uuid')
        FileUtils.rm(uuid_file)
        UUID.new)
      rescue Exception => ex
        
        puts ex.message
      end

    end
    
 protected    
    def all_keys_add(klass_name, key)
      throw :key_cannot_be_nil unless key
      coll_key = as_key(klass_name, 'all')
      all_the_keys = Rails.cache.fetch(coll_key) {[]}
      Rails.cache.write(coll_key, all_the_keys + [key])
    end
    def all_keys_remove(klass_name, key)
      throw :key_cannot_be_nil unless key
      coll_key = as_key(klass_name, 'all')
      all_the_keys = Rails.cache.fetch(coll_key) {[]}
      Rails.cache.write(coll_key, all_the_keys - [key])
    end
   end
 end
 
     end
  end
end
