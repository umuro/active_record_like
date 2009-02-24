module ConceptSpace
module ActiveRecordLike

class CachedFriend < CacheBase
  column :id, :string
#  set_primary_key "id"
  column :name, :string
end

#TODO test compulsory field
#TODO test manual id
#TODO test relation
#2357 set
#2290 get
#1166 set primary key
end
end