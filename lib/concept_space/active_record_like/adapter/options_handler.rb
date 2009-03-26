module ConceptSpace
  module ActiveRecordLike
    module Adapter

class OptionsHandler
    extend PatternMatching

    def initialize options=nil
      @klass_name = options[:klass_name] if options
      #raise ":klass_name expected" unless @klass_name
      @primary_key = (options[:primary_key] if options) || 'id'
      @adapter = options[:adapter] if options
    end

    #STARTING POINTS
    #count
    func(:plan).seems as {count(:klass, :options)} do
      reduce_adapt build { fn( 'set_size', this.setnils(find(klass, nil, options))) }
    end
    #delete
    func(:plan).seems as {delete_all(:klass, :conditions)} do
      reduce_adapt build { fn('set_each_delete', klass, this.setnils(find(klass, nil, {:conditions=>conditions}))) }
    end
    #find
    func(:plan).seems as {find_every(:klass, :options)} do
      reduce_adapt build { this.setnils(find(klass, nil,  options)) }
    end
    func(:plan).seems as {find_one_regarding(:klass,  :an_id, :options)} do
      reduce_adapt build { fn('set_first', this.setnils(find(klass, [an_id], options))) }
    end
    func(:plan).seems as {find_initial(:klass,  :options)} do
      reduce_adapt build { fn('set_first', this.setnils(find(klass,  nil, options))) }
    end
    func(:plan).seems as {find_last(:klass,  :options)} do
      reduce_adapt build { fn('set_last', this.setnils(find(klass,  nil, options))) }
    end
    func(:plan).seems as {find_some(:klass, :ids, :options)} do
      reduce_adapt build { this.setnils(find(klass, ids, options)) }
    end
    func(:plan).seems as {:value} do
      msg = "OptionsHandler: Unhandled query case: #{value.inspect}"
#      puts msg
#      Rails.logger.fatal msg
     raise msg
    end

    func(:reduce_adapt).seems as {:value} do
      adapt(reduce(value))
    end

    func(:reduce).seems as {fn(:msg, :klass, find(:klass, :ids, :options))} do
      reduce (build { fn(msg, klass, this.reduce( find(klass, ids, options))) })
    end

    func(:reduce).seems as {fn(:msg, find(:klass, :ids, :options))} do
      reduce (build { fn(msg, this.reduce( find(klass, ids, options))) })
    end

    func(:reduce).seems as {find(:klass , :ids, :options)},
    with{!options[:order].nil? } do
      order = options.delete :order
      order =  Parser::FindOrder.new(:klass_name=>klass).convert_parse order
      reduce build {  fn('set_order', this.reduce(find(klass, ids, options)) , order) }
    end

    func(:reduce).seems as {find(:klass , :ids, :options)},
    with{!options[:offset].nil? || !options[:limit].nil?} do
      offset = options.delete :offset
      limit = options.delete :limit
      reduce(build {  fn('set_offset_limit',  this.reduce(find(klass, ids, options)), [offset, limit]) })
    end

    func(:reduce).seems as {find(:klass , nil, {:conditions=>nil})} do
      build { fn('all_instances', klass) }
    end
    func(:reduce).seems as {find(:klass , :ids, {:conditions=>nil})} do
      build { fn('some_instances', klass, ids) }
    end

    func(:reduce).seems as {find(:klass , nil, {:conditions=>:conditions})}, with {String === conditions} do
      selector = Parser::FindConditions.new(:klass_name=>klass).convert_parse conditions
      reduce build { fn('set_select', fn('all_instances', klass), this.reduce(selector) ) }
    end

    func(:reduce).seems as {find(:klass , :ids, {:conditions=>:conditions})}, with {String === conditions} do
      parser = Parser::FindConditions.new(:klass_name=>klass)
      selector = parser.convert_parse conditions
      combined_selector = parser.reduce build {msg( selector, '&&', msg(ids,"include?" ,sql_ref(the.primary_key ,klass) ) )}
#      puts "combined_selector"
#      puts combined_selector.inspect
#      puts this.reduce(combined_selector).inspect
      reduce build { fn('set_select', fn('all_instances', klass), this.reduce(combined_selector )) }
    end

    func(:reduce).seems as {find(:klass, :ids, :options)} do
      build { unhandled_find(klass,ids, options) }
    end

    func(:reduce).seems as {fn('set_offset_limit', :msg, [nil, nil])} do
      msg
    end

    func(:reduce).seems as {fn("set_select" ,fn("all_instances" ,"Klass") ,false)} do
     []
   end
#    func(:reduce).seems as {fn("set_select" ,fn("all_instances" ,:klass) , msg(msg(:code, '&&', sql_ref(:c, :t) ,"==" , :value)))},
#      with {the.primary_key == c && the.klass_name == t} do
#      reduce build { fn('set_select', fn("some_instances" ,"Klass", [value]), code) }
#    end
    func(:reduce).seems as {fn("set_select" ,fn("all_instances" ,:klass) , msg(msg(sql_ref(:c, :tbl) ,"==" , :value), '&&', :code))},
      with {the.primary_key == c && the.klass_name == tbl} do
      reduce build { fn('set_select', fn("some_instances" ,"Klass", [value]), code) }
    end
    func(:reduce).seems as {fn("set_select" ,fn("all_instances" ,:klass) ,msg(sql_ref(:c, :tbl) ,"==" , :value))},
      with {the.primary_key == c && the.klass_name == tbl} do
      reduce build { fn("some_instances" ,"Klass", [value]) }
    end

#    func(:reduce).seems as {fn("set_select" ,fn("all_instances" ,:klass) , msg(:code, '&&', msg(:values ,"include?" , sql_ref(:c, :t))))},
#      with {the.primary_key == c && the.klass_name == t} do
#      reduce build { fn('set_select', fn("some_instances" ,"Klass", values), code) }
#    end
    func(:reduce).seems as {fn("set_select" ,fn("all_instances" ,:klass) , msg(msg(:values ,"include?" , sql_ref(:c, :tbl)), '&&', :code))},
      with {the.primary_key == c && the.klass_name == tbl} do
      reduce build { fn('set_select', fn("some_instances" ,"Klass", values), code) }
    end
    func(:reduce).seems as {fn("set_select" ,fn("all_instances" ,:klass) ,msg(:values ,"include?" , sql_ref(:c, :tbl)))},
      with {the.primary_key == c && the.klass_name == tbl} do
      reduce build { fn("some_instances" ,"Klass", values) }
    end

 #prioritize index lookups
    func(:reduce).seems as {msg(msg(sql_ref(:c, :tbl), '==', :value), '||', :code)},
    with {the.primary_key == c && the.klass_name == tbl} do
      build   {msg(msg(sql_ref(c, tbl), '==', value), '||', this.reduce(code))}
    end
    func(:reduce).seems as {msg(:code, '||', msg(sql_ref(:c, :tbl), '==', :value))},
    with {the.primary_key == c && the.klass_name == tbl} do
      build   {msg(msg(sql_ref(c, tbl), '==', value), '||', this.reduce(code))}
    end
    func(:reduce).seems as {msg(:code, '||', msg(msg(sql_ref(:c, :tbl), '==', :value), '||', :code2))},
    with {the.primary_key == c && the.klass_name == tbl} do
      build   {msg(msg(sql_ref(c, tbl), '==', value), '||',  this.reduce(msg(code, '||', this.reduce(code2))))}
    end
    func(:reduce).seems as {msg(msg(:values ,"include?" , sql_ref(:c, :tbl)), '||', :code)},
    with {the.primary_key == c && the.klass_name == tbl} do
      build   {msg(msg(values ,"include?" , sql_ref(c, tbl)), '||', this.reduce(code))}
    end
    func(:reduce).seems as {msg(:code, '||', msg(:values ,"include?" , sql_ref(:c, :tbl)))},
    with {the.primary_key == c && the.klass_name == tbl} do
      build   {msg(msg(values ,"include?" , sql_ref(c, tbl)), '||', this.reduce(code))}
    end
    func(:reduce).seems as {msg(:code, '||', msg(msg(:values ,"include?" , sql_ref(:c, :tbl)), '||', :code2))},
    with {the.primary_key == c && the.klass_name == tbl} do
      build   {msg(msg(values ,"include?" , sql_ref(c, tbl)), '||',  this.reduce(msg(code, '||', this.reduce(code2))))}
    end

    func(:reduce).seems as {fn('set_size',  [])} do
      0
    end
    func(:reduce).seems as {fn('set_each_delete', :_,  [])} do
      ''
    end

    func(:reduce).seems as {:value} do
      value
    end

    func(:adapt).seems as {adapter('delete', :klass, [:value])} do
      build {adapter('delete_one', klass, value)}
    end

    func(:adapt).seems as {fn('all_instances', :klass)} do
      build {adapter('find_every_regardless', klass)}
    end
    func(:adapt).seems as {fn('some_instances', :klass, :values)} do
      build {adapter('find_some_regardless', klass, values)}
    end

    func(:adapt).seems as {fn('set_each_delete', :_, fn('all_instances', :klass))} do
      build { adapter('delete_regardless', klass) }
    end
    func(:adapt).seems as {fn('set_each_delete', :_, fn('some_instances', :klass, :values))} do
      adapt build { adapter('delete', klass, values) }
    end
    func(:adapt).seems as {fn('set_each_delete', :klass, :msg)} do
      build { fn('set_each_delete', klass, this.adapt(msg)) }
    end

    func(:adapt).seems as {fn('set_offset_limit', :msg, :offset_limit)} do
      build {fn('set_offset_limit', this.adapt(msg), offset_limit)}
    end
    func(:adapt).seems as {fn('set_order', :msg, :order)} do
      build {fn('set_order', this.adapt(msg), order)}
    end

    func(:adapt).seems as { fn("set_first" ,fn("some_instances" ,"Klass" , :ids))} do
      build {adapter("find_one" ,"Klass" , ids.first)}
    end
    func(:adapt).seems as { fn("set_first" , [])} do
      nil
    end
    func(:adapt).seems as { fn("set_first" , :msg)} do
      build {fn("set_first" , this.adapt(msg))}
    end
    func(:adapt).seems as { fn("set_last" ,fn("some_instances" ,"Klass" , :ids))} do
      build {adapter("find_one" ,"Klass" , ids.first)}
    end
    func(:adapt).seems as { fn("set_last" , [])} do
      nil
    end
    func(:adapt).seems as { fn("set_last" , :msg)} do
      build {fn("set_last" , this.adapt(msg))}
    end

    func(:adapt_size).seems as {fn("set_size" ,adapter("find_every_regardless" ,:klass))} do
      build {adapter('count_regardless', klass)}
    end
    func(:adapt_size).seems as {fn("set_size" ,adapter("all_keys_regardless" ,:klass))} do
      build {adapter('count_regardless', klass)}
    end
    func(:adapt_size).seems as {:value} do
      value
    end

     func(:adapt).seems as {fn('set_size', :msg)} do
      this.adapt_size build {fn('set_size', this.adapt(msg))}
    end

    func(:adapt).seems as {fn('set_select', :msg, :code)} do
      build {fn('set_select', this.adapt(msg), code)}
    end

    func(:adapt).seems as {:value} do
      value
    end

    func(:setnils).seems as {find(:klass, :ids, :options)} do
      ids1 = ids; ids1 = nil if ids && ids.empty?

      if options.nil?
          build { find(klass, ids1, {}) }
      else
          options1 = options.dup
          options.each_pair {|key, x|
          if x
            if String === x && x.chop.empty?
                options1.delete key
            elsif Hash === x && x.empty?
                options1.delete key
            elsif Array === x && x.empty?
                options1.delete key
            end
          end
          }
          options1.delete :include unless options1[:conditions]
          raise "unsupported_option :distict=>#{options1[:distinct].inspect}}" if options1[:distinct]
          raise "unsupported_option :joins=>#{options1[:joins].inspect}" if options1[:joins]
          #raise "unsupported_option :include=>#{options1[:include].inspect}" if options1[:include]
		  # ignoring the includes do not affect anything if they are not used in the conditions.
          raise "unsupported_option :group=>#{options1[:group].inspect}" if options1[:group]
          build { find(klass, ids1, options1) }
        end
    end


     func(:eval).seems as {fn('set_order', :rows,  sql_sort_order(sql_ref(:col, :klass), :order) )} do
       raise "multi table sorting not supported" unless klass = the.klass_name
       rows1 = this.eval rows
       asc = lambda {|a, b|
       x, y = a[col], b[col]
       if x.nil?
        if y.nil?
          0
        else
            -1
        end
       else
         if y.nil?
          1
        else
            x <=> y
        end
       end}
       desc = lambda {|a, b|
        y, x = a[col], b[col]
       if x.nil?
        if y.nil?
          0
        else
            -1
        end
       else
         if y.nil?
          1
        else
            x <=> y
        end
       end}
       sorters = {'asc'=>asc, 'desc'=>desc}
       rows1.sort &(sorters[order])
     end
     func(:eval).seems as {fn('set_each_delete', :klass, :rows)} do
        rows1 = this.eval rows
        raise "eval needs primary_key" if the.primary_key.nil?
        rows1.each do | a_row |
            the.adapter.delete_one klass, a_row[the.primary_key]
        end
    end
     func(:eval).seems as {fn('set_select', :rows, :conditions)} do
       rows1 = this.eval rows
        selector = Parser::FindConditions.new(:klass_name=>the.klass_name)
        rows1.select {|a_row|
            selector.context={the.klass_name=>a_row}
            selector.eval conditions}
     end
     func(:eval).seems as {fn('set_first',  :rows)} do
       rows1 = this.eval rows
       rows1.first
     end
     func(:eval).seems as {fn('set_last',  :rows)} do
       rows1 = this.eval rows
       rows1.last
     end
     func(:eval).seems as {fn('set_offset_limit', :rows, [:offset, :limit])} do
       rows1 = this.eval rows
       offset1 = offset && offset || 0
       limit1 = limit && limit+offset1 ||  offset1 + rows1.size
       rows1[ offset1 ... limit1 ]
     end
     func(:eval).seems as {fn('set_size',  :rows)} do
       rows1 = this.eval rows
       rows1.size
     end
     func(:eval).seems as {adapter(:msg, :klass, :arg)} do
       the.adapter.send(msg, klass, arg)
     end
     func(:eval).seems as {adapter(:msg, :klass)} do
       the.adapter.send(msg, klass)
     end
     func(:eval).seems as {:value}, with{ [NilClass, Float, Fixnum, String, Array].any? {|klass| klass===value}} do
        value
    end
     func(:eval).seems as {:value} do
        raise value.inspect
    end

end #class OptionsHandler

    end
  end
end