module FindOrderSqlSyntax
  include Treetop::Runtime

  def root
    @root || :sqlFindOrderString
  end

  include FindConditionsSqlSyntax

  module SqlFindOrderString0
    def sqlFindOrder
      elements[1]
    end

  end

  module SqlFindOrderString1
    def code; sqlFindOrder.code; end
  end

  def _nt_sqlFindOrderString
    start_index = index
    if node_cache[:sqlFindOrderString].has_key?(index)
      cached = node_cache[:sqlFindOrderString][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    s1, i1 = [], index
    loop do
      r2 = _nt_SP
      if r2
        s1 << r2
      else
        break
      end
    end
    r1 = SyntaxNode.new(input, i1...index, s1)
    s0 << r1
    if r1
      r3 = _nt_sqlFindOrder
      s0 << r3
      if r3
        s4, i4 = [], index
        loop do
          r5 = _nt_SP
          if r5
            s4 << r5
          else
            break
          end
        end
        r4 = SyntaxNode.new(input, i4...index, s4)
        s0 << r4
      end
    end
    if s0.last
      r0 = (SyntaxNode).new(input, i0...index, s0)
      r0.extend(SqlFindOrderString0)
      r0.extend(SqlFindOrderString1)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:sqlFindOrderString][start_index] = r0

    return r0
  end

  module SqlFindOrder0
    def sqlRef
      elements[0]
    end

    def sqlOrder
      elements[2]
    end
  end

  module SqlFindOrder1
 
  		def code 
  			build {sql_sort_order( this.sqlRef.code, this.sqlOrder.code )}
  		end
  end

  def _nt_sqlFindOrder
    start_index = index
    if node_cache[:sqlFindOrder].has_key?(index)
      cached = node_cache[:sqlFindOrder][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    r1 = _nt_sqlRef
    s0 << r1
    if r1
      s2, i2 = [], index
      loop do
        r3 = _nt_SP
        if r3
          s2 << r3
        else
          break
        end
      end
      if s2.empty?
        self.index = i2
        r2 = nil
      else
        r2 = SyntaxNode.new(input, i2...index, s2)
      end
      s0 << r2
      if r2
        r4 = _nt_sqlOrder
        s0 << r4
      end
    end
    if s0.last
      r0 = (SyntaxNode).new(input, i0...index, s0)
      r0.extend(SqlFindOrder0)
      r0.extend(SqlFindOrder1)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:sqlFindOrder][start_index] = r0

    return r0
  end

  module SqlOrder0
  end

  module SqlOrder1
  end

  module SqlOrder2
    def code; text_value.downcase; end
  end

  def _nt_sqlOrder
    start_index = index
    if node_cache[:sqlOrder].has_key?(index)
      cached = node_cache[:sqlOrder][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    i1, s1 = index, []
    if input.index(Regexp.new('[aA]'), index) == index
      r2 = (SyntaxNode).new(input, index...(index + 1))
      @index += 1
    else
      r2 = nil
    end
    s1 << r2
    if r2
      if input.index(Regexp.new('[sS]'), index) == index
        r3 = (SyntaxNode).new(input, index...(index + 1))
        @index += 1
      else
        r3 = nil
      end
      s1 << r3
      if r3
        if input.index(Regexp.new('[cC]'), index) == index
          r4 = (SyntaxNode).new(input, index...(index + 1))
          @index += 1
        else
          r4 = nil
        end
        s1 << r4
      end
    end
    if s1.last
      r1 = (SyntaxNode).new(input, i1...index, s1)
      r1.extend(SqlOrder0)
    else
      self.index = i1
      r1 = nil
    end
    if r1
      r0 = r1
      r0.extend(SqlOrder2)
    else
      i5, s5 = index, []
      if input.index(Regexp.new('[dD]'), index) == index
        r6 = (SyntaxNode).new(input, index...(index + 1))
        @index += 1
      else
        r6 = nil
      end
      s5 << r6
      if r6
        if input.index(Regexp.new('[eE]'), index) == index
          r7 = (SyntaxNode).new(input, index...(index + 1))
          @index += 1
        else
          r7 = nil
        end
        s5 << r7
        if r7
          if input.index(Regexp.new('[sS]'), index) == index
            r8 = (SyntaxNode).new(input, index...(index + 1))
            @index += 1
          else
            r8 = nil
          end
          s5 << r8
          if r8
            if input.index(Regexp.new('[cC]'), index) == index
              r9 = (SyntaxNode).new(input, index...(index + 1))
              @index += 1
            else
              r9 = nil
            end
            s5 << r9
          end
        end
      end
      if s5.last
        r5 = (SyntaxNode).new(input, i5...index, s5)
        r5.extend(SqlOrder1)
      else
        self.index = i5
        r5 = nil
      end
      if r5
        r0 = r5
        r0.extend(SqlOrder2)
      else
        self.index = i0
        r0 = nil
      end
    end

    node_cache[:sqlOrder][start_index] = r0

    return r0
  end

end

class FindOrderSqlSyntaxParser < Treetop::Runtime::CompiledParser
  include FindOrderSqlSyntax
end
