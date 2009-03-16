require 'ConceptSpace::ActiveRecordLike::Adapter::Parser::GrammarBuilder'.underscore
require 'ConceptSpace::ActiveRecordLike::Adapter::Parser::FindConditionsSqlSyntax'.underscore
  
module ConceptSpace
  module ActiveRecordLike
    module Adapter
      module Parser

class FindOrder < GrammarBuilder
  
  class << self
    
    def grammar_file
      File.join(klass_dir, 'find_order_sql_syntax.treetop')
    end
    
    def parser_klass_name
      "FindOrderSqlSyntaxParser"
    end
      
  end#class

    def initialize options = {}
      @klass_name = options[:klass_name]
    end

    #def convert
    func(:convert).seems as{:a} do
        reduce a
    end

#sql_sort_oder
func(:reduce).seems as {sql_sort_order(:ref, :order)} do
  build {sql_sort_order( this.reduce(ref), order )}
end
#sql_ref
  func(:reduce).seems as {sql_ref(:col)}, with {!the.klass_name.nil?} do
    build {sql_ref(col, the.klass_name)}
  end
  #literal
  func(:reduce).seems as {:value} do
    value
  end

end #class FindOrder

      end
    end
  end
end