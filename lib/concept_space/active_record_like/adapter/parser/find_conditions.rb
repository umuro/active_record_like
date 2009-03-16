require 'ConceptSpace::ActiveRecordLike::Adapter::Parser::GrammarBuilder'.underscore
  
module ConceptSpace
  module ActiveRecordLike
    module Adapter
      module Parser

class FindConditions < GrammarBuilder
  
  class << self
    
    def grammar_file
      File.join(klass_dir, 'find_conditions_sql_syntax.treetop')
    end
    
    def parser_klass_name
      "FindConditionsSqlSyntaxParser"
    end
      
  end#class

     attr_accessor :context
     
    def initialize options = {}
      @klass_name = options[:klass_name]
    end

    #def convert
    func(:convert).seems as{sql_msg(:a, :op, :b)} do
      reduce build { this.trans(sql_msg(this.convert(a), op, this.convert(b))) }
    end
    func(:convert).seems as{sql_msg(:a, :op)} do
      reduce build { this.trans(sql_msg( this.convert(a), op)) }
    end
    func(:convert).seems as{cons(:a, :b)} do
      reduce build { this.trans( cons( this.convert(a), this.convert(b))) }
    end
    func(:convert).seems as{range(:a, :b)} do
      reduce build { this.trans(range( this.convert(a), this.convert(b) )) }
    end
    func(:convert).seems as{:a} do
        reduce a
    end

    F_DICT = {
      'and'=>'&&',
      'or'=>'||',
      'not'=>'!',
      '='=>'==',
      '<>'=>'!=',
      'upper'=>'upcase',
      'lower'=>'downcase',
      'is_null'=>'nil?',
      'concat'=>'+',
      '||'=>'+'
    }
    
    def all_literals? *args
      not some_nodes?(*args)
    end
    def some_nodes? *args
      args.inject(false) {|answer, arg| answer || PatternMatching::Node === arg}
    end
    
    #in
    func(:trans).seems as {sql_msg(:a, 'in', :b)} do
      build{ msg(b, 'include?', a) }
    end
    #between
    func(:trans).seems as {sql_msg(:a, 'between', :b)} do
      build{ msg(b, 'include?', a) }
    end
    #like
    func(:trans).seems as {sql_msg(:a, 'like', :b)} do
      b2 = reduce_recur(build{msg(msg(msg(b,'gsub', /^/, '^'), 'gsub', /$/, '$'), 'gsub', '%', '.*')})     
      build{ msg(a, '=~', b2)}
    end

    #others
    func(:trans).seems as {sql_msg(:a, :op, :b)} do
      op1 = F_DICT[op] || op
      build{ msg(a, op1, b)  }
    end
    
    func(:trans).seems as {sql_msg(:a, :op)} do
      op1 = F_DICT[op] || op
      build{ msg(a, op1)  }
    end

    func(:trans).seems as {range(:a, :b)} do
      a..b
    end
    func(:trans).seems as {cons(:a, :b)}, with {Array ===b} do
      [a] + b
    end
    func(:trans).seems as {cons(:a, :b)} do
      [a, b]
    end
    
    #not reductions
    func(:reduce).seems as {msg(msg(:a, '&&', :b), '!')} do
      build {msg( this.reduce(msg(a, '!')), '||' , this.reduce( msg(b, '!') ) ) }      
    end
    func(:reduce).seems as {msg(msg(:a, '||', :b), '!')} do
      build {msg( this.reduce(msg(a, '!')), '&&' , this.reduce(msg(b, '!')) ) }      
    end
    func(:reduce).seems as {msg(msg(:a, '!'), '!')} do
      a
    end
   
    func(:reduce).seems as {msg(msg(:a, '==', :b), '!')} do
      reduce build {(msg( a, '!=' , b)) }      
    end
    func(:reduce).seems as {msg(msg(:a, '!=', :b), '!')} do
      reduce build {msg( a, '==' , b) }      
    end
    func(:reduce).seems as {msg(msg(:a, '>', :b), '!')} do
      reduce build {msg( a, '<=' , b) }      
    end
    func(:reduce).seems as {msg(msg(:a, '>=', :b), '!')} do
      reduce build { msg( a, '<' , b) }      
    end
    func(:reduce).seems as {msg(msg(:a, '<', :b), '!')} do
      reduce build {msg( a, '>=' , b) }      
    end
    func(:reduce).seems as {msg(msg(:a, '<=', :b), '!')} do
      reduce build {(msg( a, '>' , b)) }      
    end

    #boolean
    func(:reduce).seems as {msg(:a, '||', :b)}, with{ a==true || b==true } do
      true
    end
    func(:reduce).seems as {msg(:a, '||', false )} do
      a
    end
    func(:reduce).seems as {msg(false, '||', :b )} do
      b
    end
    func(:reduce).seems as {msg(:a, '&&', :b)}, with{a==false || b==false } do
      false
    end
    func(:reduce).seems as {msg(:a, '&&', true )} do
      a
    end
    func(:reduce).seems as {msg(true, '&&', :b )} do
      b
    end
    func(:reduce).seems as {msg(true, '!')} do
      false
    end
    func(:reduce).seems as {msg(false, '!')} do
      true
    end   

   
  #reflexive
    func(:reduce).seems as {msg(msg(:a, '&&', :b), '&&', :c)} do
      reduce build {msg(a, '&&', this.reduce(msg(b, '&&', c)))}
    end
    func(:reduce).seems as {msg(msg(:a, '||', :b), '||', :c)} do
      reduce build {msg(a, '||', this.reduce(msg(b, '||', c))) }
    end
  #contradiction
    func(:reduce).seems as {msg(msg(:a, '==', :b), '&&', msg(:_, '&&', msg(msg(:c, '==', :d), '&&', :_)))}, 
    with {a == c && b != d} do
      false
    end
    func(:reduce).seems as {msg(msg(:a, '==', :b), '&&', msg(msg(:c, '==', :d), '&&', :_))}, 
    with {a == c && b != d} do
      false
    end
    func(:reduce).seems as {msg(msg(:a, '==', :b), '&&', msg(:c, '==', :d))}, with {a == c && b != d} do
      false
    end
    #collected tests
    func(:reduce).seems as {msg(msg(:a, '==', :b), '||', msg(msg(:c, '==', :d), '||', :code))}, 
    with {a == c} do
      reduce build {msg(msg([d,b], 'include?', a), '||', code)}
    end

    func(:reduce).seems as {msg(msg(:a, '==', :b), '||', msg(:c, '==', :d))}, 
    with {a == c} do
      reduce build {msg([d,b], 'include?', a)}
    end
    func(:reduce).seems as {msg(msg(:a, '==', :b), '||', msg(:code, '||', msg(:c, '==', :d)))}, 
    with {a == c} do
      reduce build {msg(msg([d,b], 'include?', a), '||', code)}
    end
    func(:reduce).seems as {msg(msg(:a, '==', :b), '||', msg(:code, '||', msg(msg(:c, '==', :d), '||',  :code2)))}, 
    with {a == c} do
      reduce build {msg(msg([d,b], 'include?', a), '||', msg(code, '||', code2))}
    end


    func(:reduce).seems as {msg(msg(:c, '==', :d), '||', msg(:values, 'include?', :a) )}, 
    with {a == c} do
      reduce build {msg(values << d, 'include?', a)}
    end
    func(:reduce).seems as {msg(msg(:c, '==', :d), '||', msg(:code, '||', msg(:values, 'include?', :a)) )}, 
    with {a == c} do
      reduce build {msg(msg(values << d, 'include?', a), '||', code)}
    end
    func(:reduce).seems as {msg(msg(:c, '==', :d), '||', msg(:code, '||', msg(msg(:values, 'include?', :a), '||', :code2) ))}, 
    with {a == c} do
      reduce build {msg(msg(values << d, 'include?', a), '||', msg(code, '||', code2))}
    end

#redundancy
    func(:reduce).seems as {msg(msg(:c, '==', :d), '&&', msg(:other, '&&', msg(:values, 'include?', :a) ))}, 
    with {a == c} do
      reduce build {msg(msg([d]  & values, 'include?', a), '&&', other)}
    end
    func(:reduce).seems as {msg(msg(:c, '==', :d), '&&', msg(:values, 'include?', :a) )}, 
    with {a == c} do
      reduce build {msg([d]  & values, 'include?', a)}
    end
    func(:reduce).seems as {msg(msg(:values, 'include?', :a), '&&', msg(:c, '==', :d) )}, 
    with {a == c} do
      reduce build {msg([d]  & values, 'include?', a)}
    end
    func(:reduce).seems as {msg(msg(:values1, 'include?', :a), '&&', msg(:values2, 'include?', :c) )}, 
    with {a == c} do
      reduce build {msg(values1 & values2, 'include?', a)}
    end
    func(:reduce).seems as { msg( [] ,"include?" , :_  )} do
      false
    end

   #distribution
    func(:reduce).seems as {msg(msg(:a, '||', :b), '&&', :c)} do
      a1 = reduce(build{msg(a, '&&', c)})
      b1 = reduce(build{msg(b, '&&', c)}) 
      if TrueClass === a1 || FalseClass === a1 || TrueClass === b1 || FalseClass === b1
        reduce build {msg(a1, '||', b1)}
      else
        build {msg(msg(a, '||', b), '&&', c)}
      end
    end
    func(:reduce).seems as {msg(:c, '&&', msg(:a, '||', :b))} do
      puts "Distributing"
      a1 = reduce(msg(a, '&&', c))
      b1 = reduce(msg(b, '&&', c)) 
      if TrueClass === a1 || FalseClass === a1 || TrueClass === b1 || FalseClass === b1
        reduce build {msg(a1, '||', b1)}
      else
        build {msg(msg(:a, '||', :b), '&&', :c)}
      end
    end


#comparison
    func(:reduce).seems as {msg(:a, '==', :b)},
    with {all_literals?(a, b)} do
        a == b
    end
    func(:reduce).seems as {msg(:a, '!=', :b)},
    with {all_literals?(a,b)} do
        a != b
    end
    func(:reduce).seems as {msg(:a, '==', sql_ref(:c, :tbl))}, with{all_literals?(a)} do
      build {msg(sql_ref(c, tbl), '==', a)}
    end
    func(:reduce).seems as {msg(:a, '!=', sql_ref(:c, :tbl))}, with{all_literals?(a)} do
      build {msg(sql_ref(c, tbl), '!=', a)}
    end

#arithmetic
    func(:reduce).seems as {msg(msg(:a, '-'), '-')} do
      a
    end
    func(:reduce).seems as {msg(:a, '-')}, with{Numeric === a} do
      -a
    end
    func(:reduce).seems as {msg(:a, '+')}, with{Numeric === a} do
      +a
    end

#msg special cases
    func(:reduce).seems as {msg(:a, '=~', :b)}, with{all_literals?(a, b) && String===b} do
      b1 = Regexp.new(b)
      a =~ b1
    end
    func(:reduce).seems as {msg(nil,  :op, :b)} do
      nil
    end
    func(:reduce).seems as {msg(nil,  :op)} do
      nil
    end
#msg
    func(:reduce).seems as {send_msg(:a, :op, :args)}, with{all_literals?(a, *args)} do
      a.send(op, b, *args)
    end    
    func(:reduce).seems as {msg(:a, :op, :b, :c)}, with{all_literals?(a, b, c)} do
      a.send(op, b, c)
    end    

    func(:reduce).seems as {msg(:a, :op, :b)}, with{all_literals?(a, b)} do
      a.send(op, b)
    end    
    func(:reduce).seems as {msg(:a, :op)}, with{all_literals?(a)} do
      a.send(op)
    end    
#range
    func(:reduce).seems as {:value}, 
    with {Range === value && Integer === value.first && Integer === value.last && (value.last-value.first) < 40} do
      value.to_a
    end
#sql_ref
  func(:reduce).seems as {sql_ref(:col)}, with {!the.klass_name.nil?} do
    build {sql_ref(col, the.klass_name)}
  end
  #literal
  func(:reduce).seems as {:value} do
    value
  end

#TODO same with eval
  func(:reduce_recur).seems as {send_msg(:a, :op, :args)} do
    args1 = args.collect{|arg| reduce_recur(arg)}
    reduce (build {send_msg( this.reduce_recur(a), op, args1)})
  end
  func(:reduce_recur).seems as {msg(:a, :op, :b, :c)} do
    reduce build {msg(this.reduce_recur(a), op, this.reduce_recur(b), this.reduce_recur(c))}
  end
  func(:reduce_recur).seems as {msg(:a, :op, :b)} do
    reduce (build {msg(this.reduce_recur(a), op, this.reduce_recur(b))})
  end
  func(:reduce_recur).seems as {msg(:a, :op)} do
    reduce (build {msg( this.reduce_recur(a), op)})
  end
  func(:reduce_recur).seems as {:value} do
    reduce value
  end
   
  func(:eval).seems as {sql_ref(:column, :table)} do
    raise "Table #{table} not in context" unless the.context.has_key?(table)
#    raise "Table #{table} do not have column #{column}" unless the.context[table].has_key?(column)
    context[table][column] 
  end  
  func(:eval).seems as {sql_ref(:column)} do
    table = the.klass_name
    raise "Table #{table} not in context" unless the.context.has_key?(table)
 #   raise "Table #{table} do not have column #{column}" unless the.context[table].has_key?(column)
    context[table][column]
  end
  func(:eval).seems as {send_msg(:a, :op, :args)} do
    args1 =  args.collect{|arg| eval(arg)}
    reduce build{msg( this.eval(a), op, args1)}
  end
  func(:eval).seems as {msg(:a, :op, :b, :c)} do
    reduce build{msg( this.eval(a), op1, this.eval(b), this.eval(c))}
  end
  func(:eval).seems as {msg(:a, :op, :b)} do
    reduce build{msg( this.eval(a), op, this.eval(b))}
  end  
  func(:eval).seems as {msg(:a, :op)} do
    reduce build{msg( this.eval(a), op)}
  end
  func(:eval).seems as {:value} do
    value
  end
  
end #class FindConditions

      end
    end
  end
end