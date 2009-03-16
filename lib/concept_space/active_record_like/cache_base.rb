# If this require is not in place
# then Aptana uses its own class loader
# which fails
require 'concept_space/active_record_like/adapter/cache_adapter'

module ConceptSpace
module ActiveRecordLike

class CacheBase < Base
#  adapter ConceptSpace::ActiveRecordLike::Adapter::CacheAdapter
  adapter Adapter::Verbose.new(Adapter::CacheAdapter)
end

end
end
