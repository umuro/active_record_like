module FindConditionsSqlSyntax
  include Treetop::Runtime

  def root
    @root || :sqlFindConditions
  end

  module SqlFindConditions0
    def sqlBoolOrExpression
      elements[1]
    end

  end

  module SqlFindConditions1
    def code; sqlBoolOrExpression.code; end
  end

  def _nt_sqlFindConditions
    start_index = index
    if node_cache[:sqlFindConditions].has_key?(index)
      cached = node_cache[:sqlFindConditions][index]
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
      r3 = _nt_sqlBoolOrExpression
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
      r0.extend(SqlFindConditions0)
      r0.extend(SqlFindConditions1)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:sqlFindConditions][start_index] = r0

    return r0
  end

  module SqlBoolOrExpression0
    def sqlBoolAndExpression
      elements[0]
    end

    def EOWSP
      elements[4]
    end

    def sqlBoolOrExpression
      elements[5]
    end
  end

  module SqlBoolOrExpression1
    	def code
    		build { sql_msg(this.sqlBoolAndExpression.code, 'or', this.sqlBoolOrExpression.code) }	
    	end
  end

  def _nt_sqlBoolOrExpression
    start_index = index
    if node_cache[:sqlBoolOrExpression].has_key?(index)
      cached = node_cache[:sqlBoolOrExpression][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    i1, s1 = index, []
    r2 = _nt_sqlBoolAndExpression
    s1 << r2
    if r2
      s3, i3 = [], index
      loop do
        r4 = _nt_SP
        if r4
          s3 << r4
        else
          break
        end
      end
      r3 = SyntaxNode.new(input, i3...index, s3)
      s1 << r3
      if r3
        if input.index(Regexp.new('[oO]'), index) == index
          r5 = (SyntaxNode).new(input, index...(index + 1))
          @index += 1
        else
          r5 = nil
        end
        s1 << r5
        if r5
          if input.index(Regexp.new('[rR]'), index) == index
            r6 = (SyntaxNode).new(input, index...(index + 1))
            @index += 1
          else
            r6 = nil
          end
          s1 << r6
          if r6
            r7 = _nt_EOWSP
            s1 << r7
            if r7
              r8 = _nt_sqlBoolOrExpression
              s1 << r8
            end
          end
        end
      end
    end
    if s1.last
      r1 = (SyntaxNode).new(input, i1...index, s1)
      r1.extend(SqlBoolOrExpression0)
      r1.extend(SqlBoolOrExpression1)
    else
      self.index = i1
      r1 = nil
    end
    if r1
      r0 = r1
    else
      r9 = _nt_sqlBoolAndExpression
      if r9
        r0 = r9
      else
        self.index = i0
        r0 = nil
      end
    end

    node_cache[:sqlBoolOrExpression][start_index] = r0

    return r0
  end

  module SqlBoolAndExpression0
    def sqlBoolNotExpression
      elements[0]
    end

    def EOWSP
      elements[5]
    end

    def sqlBoolAndExpression
      elements[6]
    end
  end

  module SqlBoolAndExpression1
    	def code
    		build { sql_msg(this.sqlBoolNotExpression.code, 'and', this.sqlBoolAndExpression.code) }	
    	end
  end

  def _nt_sqlBoolAndExpression
    start_index = index
    if node_cache[:sqlBoolAndExpression].has_key?(index)
      cached = node_cache[:sqlBoolAndExpression][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    i1, s1 = index, []
    r2 = _nt_sqlBoolNotExpression
    s1 << r2
    if r2
      s3, i3 = [], index
      loop do
        r4 = _nt_SP
        if r4
          s3 << r4
        else
          break
        end
      end
      r3 = SyntaxNode.new(input, i3...index, s3)
      s1 << r3
      if r3
        if input.index(Regexp.new('[aA]'), index) == index
          r5 = (SyntaxNode).new(input, index...(index + 1))
          @index += 1
        else
          r5 = nil
        end
        s1 << r5
        if r5
          if input.index(Regexp.new('[nN]'), index) == index
            r6 = (SyntaxNode).new(input, index...(index + 1))
            @index += 1
          else
            r6 = nil
          end
          s1 << r6
          if r6
            if input.index(Regexp.new('[dD]'), index) == index
              r7 = (SyntaxNode).new(input, index...(index + 1))
              @index += 1
            else
              r7 = nil
            end
            s1 << r7
            if r7
              r8 = _nt_EOWSP
              s1 << r8
              if r8
                r9 = _nt_sqlBoolAndExpression
                s1 << r9
              end
            end
          end
        end
      end
    end
    if s1.last
      r1 = (SyntaxNode).new(input, i1...index, s1)
      r1.extend(SqlBoolAndExpression0)
      r1.extend(SqlBoolAndExpression1)
    else
      self.index = i1
      r1 = nil
    end
    if r1
      r0 = r1
    else
      r10 = _nt_sqlBoolNotExpression
      if r10
        r0 = r10
      else
        self.index = i0
        r0 = nil
      end
    end

    node_cache[:sqlBoolAndExpression][start_index] = r0

    return r0
  end

  module SqlBoolNotExpression0
    def EOWSP
      elements[3]
    end

    def sqlBoolNotExpression
      elements[4]
    end
  end

  module SqlBoolNotExpression1
  		def code
  			build { sql_msg(this.sqlBoolNotExpression.code, 'not') }
  		end
  end

  def _nt_sqlBoolNotExpression
    start_index = index
    if node_cache[:sqlBoolNotExpression].has_key?(index)
      cached = node_cache[:sqlBoolNotExpression][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    i1, s1 = index, []
    if input.index(Regexp.new('[nN]'), index) == index
      r2 = (SyntaxNode).new(input, index...(index + 1))
      @index += 1
    else
      r2 = nil
    end
    s1 << r2
    if r2
      if input.index(Regexp.new('[oO]'), index) == index
        r3 = (SyntaxNode).new(input, index...(index + 1))
        @index += 1
      else
        r3 = nil
      end
      s1 << r3
      if r3
        if input.index(Regexp.new('[tT]'), index) == index
          r4 = (SyntaxNode).new(input, index...(index + 1))
          @index += 1
        else
          r4 = nil
        end
        s1 << r4
        if r4
          r5 = _nt_EOWSP
          s1 << r5
          if r5
            r6 = _nt_sqlBoolNotExpression
            s1 << r6
          end
        end
      end
    end
    if s1.last
      r1 = (SyntaxNode).new(input, i1...index, s1)
      r1.extend(SqlBoolNotExpression0)
      r1.extend(SqlBoolNotExpression1)
    else
      self.index = i1
      r1 = nil
    end
    if r1
      r0 = r1
    else
      r7 = _nt_sqlBoolTruthExpression
      if r7
        r0 = r7
      else
        self.index = i0
        r0 = nil
      end
    end

    node_cache[:sqlBoolNotExpression][start_index] = r0

    return r0
  end

  module SqlBoolTruthExpression0
    def sqlBoolOrExpression
      elements[2]
    end

  end

  module SqlBoolTruthExpression1
    def code; sqlBoolOrExpression.code; end
  end

  def _nt_sqlBoolTruthExpression
    start_index = index
    if node_cache[:sqlBoolTruthExpression].has_key?(index)
      cached = node_cache[:sqlBoolTruthExpression][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    i1, s1 = index, []
    if input.index('(', index) == index
      r2 = (SyntaxNode).new(input, index...(index + 1))
      @index += 1
    else
      terminal_parse_failure('(')
      r2 = nil
    end
    s1 << r2
    if r2
      s3, i3 = [], index
      loop do
        r4 = _nt_SP
        if r4
          s3 << r4
        else
          break
        end
      end
      r3 = SyntaxNode.new(input, i3...index, s3)
      s1 << r3
      if r3
        r5 = _nt_sqlBoolOrExpression
        s1 << r5
        if r5
          s6, i6 = [], index
          loop do
            r7 = _nt_SP
            if r7
              s6 << r7
            else
              break
            end
          end
          r6 = SyntaxNode.new(input, i6...index, s6)
          s1 << r6
          if r6
            if input.index(')', index) == index
              r8 = (SyntaxNode).new(input, index...(index + 1))
              @index += 1
            else
              terminal_parse_failure(')')
              r8 = nil
            end
            s1 << r8
          end
        end
      end
    end
    if s1.last
      r1 = (SyntaxNode).new(input, i1...index, s1)
      r1.extend(SqlBoolTruthExpression0)
      r1.extend(SqlBoolTruthExpression1)
    else
      self.index = i1
      r1 = nil
    end
    if r1
      r0 = r1
    else
      r9 = _nt_sqlBoolTestExpression
      if r9
        r0 = r9
      else
        self.index = i0
        r0 = nil
      end
    end

    node_cache[:sqlBoolTruthExpression][start_index] = r0

    return r0
  end

  def _nt_sqlBoolTestExpression
    start_index = index
    if node_cache[:sqlBoolTestExpression].has_key?(index)
      cached = node_cache[:sqlBoolTestExpression][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    r1 = _nt_sqlBoolBetweenExpression
    if r1
      r0 = r1
    else
      r2 = _nt_sqlBoolNullExpression
      if r2
        r0 = r2
      else
        r3 = _nt_sqlBoolInExpression
        if r3
          r0 = r3
        else
          r4 = _nt_sqlBoolComparison
          if r4
            r0 = r4
          else
            self.index = i0
            r0 = nil
          end
        end
      end
    end

    node_cache[:sqlBoolTestExpression][start_index] = r0

    return r0
  end

  module SqlBoolNullExpression0
    def sqlRef
      elements[0]
    end

    def EOW
      elements[9]
    end
  end

  module SqlBoolNullExpression1
  		def code
  			build {sql_msg(this.sqlRef.code, 'is_null')}
  		end
  end

  module SqlBoolNullExpression2
    def sqlRef
      elements[0]
    end

    def EOW
      elements[13]
    end
  end

  module SqlBoolNullExpression3
  		def code
  			build {sql_msg(sql_msg(this.sqlRef.code, 'is_null'), 'not')}
  		end
  end

  def _nt_sqlBoolNullExpression
    start_index = index
    if node_cache[:sqlBoolNullExpression].has_key?(index)
      cached = node_cache[:sqlBoolNullExpression][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    i1, s1 = index, []
    r2 = _nt_sqlRef
    s1 << r2
    if r2
      s3, i3 = [], index
      loop do
        r4 = _nt_SP
        if r4
          s3 << r4
        else
          break
        end
      end
      r3 = SyntaxNode.new(input, i3...index, s3)
      s1 << r3
      if r3
        if input.index(Regexp.new('[iI]'), index) == index
          r5 = (SyntaxNode).new(input, index...(index + 1))
          @index += 1
        else
          r5 = nil
        end
        s1 << r5
        if r5
          if input.index(Regexp.new('[sS]'), index) == index
            r6 = (SyntaxNode).new(input, index...(index + 1))
            @index += 1
          else
            r6 = nil
          end
          s1 << r6
          if r6
            s7, i7 = [], index
            loop do
              r8 = _nt_SP
              if r8
                s7 << r8
              else
                break
              end
            end
            if s7.empty?
              self.index = i7
              r7 = nil
            else
              r7 = SyntaxNode.new(input, i7...index, s7)
            end
            s1 << r7
            if r7
              if input.index(Regexp.new('[nN]'), index) == index
                r9 = (SyntaxNode).new(input, index...(index + 1))
                @index += 1
              else
                r9 = nil
              end
              s1 << r9
              if r9
                if input.index(Regexp.new('[uU]'), index) == index
                  r10 = (SyntaxNode).new(input, index...(index + 1))
                  @index += 1
                else
                  r10 = nil
                end
                s1 << r10
                if r10
                  if input.index(Regexp.new('[lL]'), index) == index
                    r11 = (SyntaxNode).new(input, index...(index + 1))
                    @index += 1
                  else
                    r11 = nil
                  end
                  s1 << r11
                  if r11
                    if input.index(Regexp.new('[lL]'), index) == index
                      r12 = (SyntaxNode).new(input, index...(index + 1))
                      @index += 1
                    else
                      r12 = nil
                    end
                    s1 << r12
                    if r12
                      r13 = _nt_EOW
                      s1 << r13
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
    if s1.last
      r1 = (SyntaxNode).new(input, i1...index, s1)
      r1.extend(SqlBoolNullExpression0)
      r1.extend(SqlBoolNullExpression1)
    else
      self.index = i1
      r1 = nil
    end
    if r1
      r0 = r1
    else
      i14, s14 = index, []
      r15 = _nt_sqlRef
      s14 << r15
      if r15
        s16, i16 = [], index
        loop do
          r17 = _nt_SP
          if r17
            s16 << r17
          else
            break
          end
        end
        r16 = SyntaxNode.new(input, i16...index, s16)
        s14 << r16
        if r16
          if input.index(Regexp.new('[iI]'), index) == index
            r18 = (SyntaxNode).new(input, index...(index + 1))
            @index += 1
          else
            r18 = nil
          end
          s14 << r18
          if r18
            if input.index(Regexp.new('[sS]'), index) == index
              r19 = (SyntaxNode).new(input, index...(index + 1))
              @index += 1
            else
              r19 = nil
            end
            s14 << r19
            if r19
              s20, i20 = [], index
              loop do
                r21 = _nt_SP
                if r21
                  s20 << r21
                else
                  break
                end
              end
              if s20.empty?
                self.index = i20
                r20 = nil
              else
                r20 = SyntaxNode.new(input, i20...index, s20)
              end
              s14 << r20
              if r20
                if input.index(Regexp.new('[nN]'), index) == index
                  r22 = (SyntaxNode).new(input, index...(index + 1))
                  @index += 1
                else
                  r22 = nil
                end
                s14 << r22
                if r22
                  if input.index(Regexp.new('[oO]'), index) == index
                    r23 = (SyntaxNode).new(input, index...(index + 1))
                    @index += 1
                  else
                    r23 = nil
                  end
                  s14 << r23
                  if r23
                    if input.index(Regexp.new('[tT]'), index) == index
                      r24 = (SyntaxNode).new(input, index...(index + 1))
                      @index += 1
                    else
                      r24 = nil
                    end
                    s14 << r24
                    if r24
                      s25, i25 = [], index
                      loop do
                        r26 = _nt_SP
                        if r26
                          s25 << r26
                        else
                          break
                        end
                      end
                      if s25.empty?
                        self.index = i25
                        r25 = nil
                      else
                        r25 = SyntaxNode.new(input, i25...index, s25)
                      end
                      s14 << r25
                      if r25
                        if input.index(Regexp.new('[nN]'), index) == index
                          r27 = (SyntaxNode).new(input, index...(index + 1))
                          @index += 1
                        else
                          r27 = nil
                        end
                        s14 << r27
                        if r27
                          if input.index(Regexp.new('[uU]'), index) == index
                            r28 = (SyntaxNode).new(input, index...(index + 1))
                            @index += 1
                          else
                            r28 = nil
                          end
                          s14 << r28
                          if r28
                            if input.index(Regexp.new('[lL]'), index) == index
                              r29 = (SyntaxNode).new(input, index...(index + 1))
                              @index += 1
                            else
                              r29 = nil
                            end
                            s14 << r29
                            if r29
                              if input.index(Regexp.new('[lL]'), index) == index
                                r30 = (SyntaxNode).new(input, index...(index + 1))
                                @index += 1
                              else
                                r30 = nil
                              end
                              s14 << r30
                              if r30
                                r31 = _nt_EOW
                                s14 << r31
                              end
                            end
                          end
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
      if s14.last
        r14 = (SyntaxNode).new(input, i14...index, s14)
        r14.extend(SqlBoolNullExpression2)
        r14.extend(SqlBoolNullExpression3)
      else
        self.index = i14
        r14 = nil
      end
      if r14
        r0 = r14
      else
        self.index = i0
        r0 = nil
      end
    end

    node_cache[:sqlBoolNullExpression][start_index] = r0

    return r0
  end

  module SqlBoolInExpression0
    def sqlArithmetic
      elements[0]
    end

    def EOWSP
      elements[4]
    end

    def sqlRange
      elements[5]
    end
  end

  module SqlBoolInExpression1
  		def code
  			build {sql_msg(this.sqlArithmetic.code, 'in', this.sqlRange.code)}
  		end
  end

  module SqlBoolInExpression2
    def sqlArithmetic
      elements[0]
    end

    def EOWSP
      elements[8]
    end

    def sqlRange
      elements[9]
    end
  end

  module SqlBoolInExpression3
  		def code
  			build {sql_msg(sql_msg(this.sqlArithmetic.code, 'in', this.sqlRange.code), 'not')}
  		end
  end

  def _nt_sqlBoolInExpression
    start_index = index
    if node_cache[:sqlBoolInExpression].has_key?(index)
      cached = node_cache[:sqlBoolInExpression][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    i1, s1 = index, []
    r2 = _nt_sqlArithmetic
    s1 << r2
    if r2
      s3, i3 = [], index
      loop do
        r4 = _nt_SP
        if r4
          s3 << r4
        else
          break
        end
      end
      r3 = SyntaxNode.new(input, i3...index, s3)
      s1 << r3
      if r3
        if input.index(Regexp.new('[iI]'), index) == index
          r5 = (SyntaxNode).new(input, index...(index + 1))
          @index += 1
        else
          r5 = nil
        end
        s1 << r5
        if r5
          if input.index(Regexp.new('[nN]'), index) == index
            r6 = (SyntaxNode).new(input, index...(index + 1))
            @index += 1
          else
            r6 = nil
          end
          s1 << r6
          if r6
            r7 = _nt_EOWSP
            s1 << r7
            if r7
              r8 = _nt_sqlRange
              s1 << r8
            end
          end
        end
      end
    end
    if s1.last
      r1 = (SyntaxNode).new(input, i1...index, s1)
      r1.extend(SqlBoolInExpression0)
      r1.extend(SqlBoolInExpression1)
    else
      self.index = i1
      r1 = nil
    end
    if r1
      r0 = r1
    else
      i9, s9 = index, []
      r10 = _nt_sqlArithmetic
      s9 << r10
      if r10
        s11, i11 = [], index
        loop do
          r12 = _nt_SP
          if r12
            s11 << r12
          else
            break
          end
        end
        r11 = SyntaxNode.new(input, i11...index, s11)
        s9 << r11
        if r11
          if input.index(Regexp.new('[nN]'), index) == index
            r13 = (SyntaxNode).new(input, index...(index + 1))
            @index += 1
          else
            r13 = nil
          end
          s9 << r13
          if r13
            if input.index(Regexp.new('[oO]'), index) == index
              r14 = (SyntaxNode).new(input, index...(index + 1))
              @index += 1
            else
              r14 = nil
            end
            s9 << r14
            if r14
              if input.index(Regexp.new('[tT]'), index) == index
                r15 = (SyntaxNode).new(input, index...(index + 1))
                @index += 1
              else
                r15 = nil
              end
              s9 << r15
              if r15
                s16, i16 = [], index
                loop do
                  r17 = _nt_SP
                  if r17
                    s16 << r17
                  else
                    break
                  end
                end
                if s16.empty?
                  self.index = i16
                  r16 = nil
                else
                  r16 = SyntaxNode.new(input, i16...index, s16)
                end
                s9 << r16
                if r16
                  if input.index(Regexp.new('[iI]'), index) == index
                    r18 = (SyntaxNode).new(input, index...(index + 1))
                    @index += 1
                  else
                    r18 = nil
                  end
                  s9 << r18
                  if r18
                    if input.index(Regexp.new('[nN]'), index) == index
                      r19 = (SyntaxNode).new(input, index...(index + 1))
                      @index += 1
                    else
                      r19 = nil
                    end
                    s9 << r19
                    if r19
                      r20 = _nt_EOWSP
                      s9 << r20
                      if r20
                        r21 = _nt_sqlRange
                        s9 << r21
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
      if s9.last
        r9 = (SyntaxNode).new(input, i9...index, s9)
        r9.extend(SqlBoolInExpression2)
        r9.extend(SqlBoolInExpression3)
      else
        self.index = i9
        r9 = nil
      end
      if r9
        r0 = r9
      else
        self.index = i0
        r0 = nil
      end
    end

    node_cache[:sqlBoolInExpression][start_index] = r0

    return r0
  end

  module SqlRange0
    def sqlLiteralsWComma
      elements[1]
    end

  end

  module SqlRange1
    def code; sqlLiteralsWComma.code; end
  end

  def _nt_sqlRange
    start_index = index
    if node_cache[:sqlRange].has_key?(index)
      cached = node_cache[:sqlRange][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    if input.index('(', index) == index
      r1 = (SyntaxNode).new(input, index...(index + 1))
      @index += 1
    else
      terminal_parse_failure('(')
      r1 = nil
    end
    s0 << r1
    if r1
      r2 = _nt_sqlLiteralsWComma
      s0 << r2
      if r2
        if input.index(')', index) == index
          r3 = (SyntaxNode).new(input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure(')')
          r3 = nil
        end
        s0 << r3
      end
    end
    if s0.last
      r0 = (SyntaxNode).new(input, i0...index, s0)
      r0.extend(SqlRange0)
      r0.extend(SqlRange1)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:sqlRange][start_index] = r0

    return r0
  end

  module SqlLiteralsWComma0
    def sqlLiteral
      elements[0]
    end

    def sqlLiteralsWComma
      elements[4]
    end
  end

  module SqlLiteralsWComma1
  		def code
  			build {cons(this.sqlLiteral.code, this.sqlLiteralsWComma.code)}
  		end
  end

  def _nt_sqlLiteralsWComma
    start_index = index
    if node_cache[:sqlLiteralsWComma].has_key?(index)
      cached = node_cache[:sqlLiteralsWComma][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    i1, s1 = index, []
    r2 = _nt_sqlLiteral
    s1 << r2
    if r2
      s3, i3 = [], index
      loop do
        r4 = _nt_SP
        if r4
          s3 << r4
        else
          break
        end
      end
      r3 = SyntaxNode.new(input, i3...index, s3)
      s1 << r3
      if r3
        if input.index(',', index) == index
          r5 = (SyntaxNode).new(input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure(',')
          r5 = nil
        end
        s1 << r5
        if r5
          s6, i6 = [], index
          loop do
            r7 = _nt_SP
            if r7
              s6 << r7
            else
              break
            end
          end
          r6 = SyntaxNode.new(input, i6...index, s6)
          s1 << r6
          if r6
            r8 = _nt_sqlLiteralsWComma
            s1 << r8
          end
        end
      end
    end
    if s1.last
      r1 = (SyntaxNode).new(input, i1...index, s1)
      r1.extend(SqlLiteralsWComma0)
      r1.extend(SqlLiteralsWComma1)
    else
      self.index = i1
      r1 = nil
    end
    if r1
      r0 = r1
    else
      r9 = _nt_sqlLiteral
      if r9
        r0 = r9
      else
        self.index = i0
        r0 = nil
      end
    end

    node_cache[:sqlLiteralsWComma][start_index] = r0

    return r0
  end

  module SqlBoolBetweenExpression0
    def sqlArithmetic
      elements[0]
    end

    def EOWSP
      elements[9]
    end

    def sqlArithmetic2
      elements[10]
    end

    def EOWSP
      elements[15]
    end

    def sqlArithmetic3
      elements[16]
    end
  end

  module SqlBoolBetweenExpression1
  		def code
  			build {sql_msg(this.sqlArithmetic.code, 'between', range(this.sqlArithmetic2.code, this.sqlArithmetic3.code))}
  		end
  end

  def _nt_sqlBoolBetweenExpression
    start_index = index
    if node_cache[:sqlBoolBetweenExpression].has_key?(index)
      cached = node_cache[:sqlBoolBetweenExpression][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    r1 = _nt_sqlArithmetic
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
      r2 = SyntaxNode.new(input, i2...index, s2)
      s0 << r2
      if r2
        if input.index(Regexp.new('[bB]'), index) == index
          r4 = (SyntaxNode).new(input, index...(index + 1))
          @index += 1
        else
          r4 = nil
        end
        s0 << r4
        if r4
          if input.index(Regexp.new('[eE]'), index) == index
            r5 = (SyntaxNode).new(input, index...(index + 1))
            @index += 1
          else
            r5 = nil
          end
          s0 << r5
          if r5
            if input.index(Regexp.new('[tT]'), index) == index
              r6 = (SyntaxNode).new(input, index...(index + 1))
              @index += 1
            else
              r6 = nil
            end
            s0 << r6
            if r6
              if input.index(Regexp.new('[wW]'), index) == index
                r7 = (SyntaxNode).new(input, index...(index + 1))
                @index += 1
              else
                r7 = nil
              end
              s0 << r7
              if r7
                if input.index(Regexp.new('[eE]'), index) == index
                  r8 = (SyntaxNode).new(input, index...(index + 1))
                  @index += 1
                else
                  r8 = nil
                end
                s0 << r8
                if r8
                  if input.index(Regexp.new('[eE]'), index) == index
                    r9 = (SyntaxNode).new(input, index...(index + 1))
                    @index += 1
                  else
                    r9 = nil
                  end
                  s0 << r9
                  if r9
                    if input.index(Regexp.new('[nN]'), index) == index
                      r10 = (SyntaxNode).new(input, index...(index + 1))
                      @index += 1
                    else
                      r10 = nil
                    end
                    s0 << r10
                    if r10
                      r11 = _nt_EOWSP
                      s0 << r11
                      if r11
                        r12 = _nt_sqlArithmetic2
                        s0 << r12
                        if r12
                          s13, i13 = [], index
                          loop do
                            r14 = _nt_SP
                            if r14
                              s13 << r14
                            else
                              break
                            end
                          end
                          r13 = SyntaxNode.new(input, i13...index, s13)
                          s0 << r13
                          if r13
                            if input.index(Regexp.new('[aA]'), index) == index
                              r15 = (SyntaxNode).new(input, index...(index + 1))
                              @index += 1
                            else
                              r15 = nil
                            end
                            s0 << r15
                            if r15
                              if input.index(Regexp.new('[nN]'), index) == index
                                r16 = (SyntaxNode).new(input, index...(index + 1))
                                @index += 1
                              else
                                r16 = nil
                              end
                              s0 << r16
                              if r16
                                if input.index(Regexp.new('[dD]'), index) == index
                                  r17 = (SyntaxNode).new(input, index...(index + 1))
                                  @index += 1
                                else
                                  r17 = nil
                                end
                                s0 << r17
                                if r17
                                  r18 = _nt_EOWSP
                                  s0 << r18
                                  if r18
                                    r19 = _nt_sqlArithmetic3
                                    s0 << r19
                                  end
                                end
                              end
                            end
                          end
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
    if s0.last
      r0 = (SyntaxNode).new(input, i0...index, s0)
      r0.extend(SqlBoolBetweenExpression0)
      r0.extend(SqlBoolBetweenExpression1)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:sqlBoolBetweenExpression][start_index] = r0

    return r0
  end

  module SqlBoolComparison0
    def sqlArithmetic
      elements[0]
    end

    def sqlBoolComparisonOperator
      elements[2]
    end

    def sqlArithmetic2
      elements[4]
    end
  end

  module SqlBoolComparison1
    	def code
    		build { sql_msg( this.sqlArithmetic.code, this.sqlBoolComparisonOperator.code, this.sqlArithmetic2.code) }
    	end
  end

  def _nt_sqlBoolComparison
    start_index = index
    if node_cache[:sqlBoolComparison].has_key?(index)
      cached = node_cache[:sqlBoolComparison][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    r1 = _nt_sqlArithmetic
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
      r2 = SyntaxNode.new(input, i2...index, s2)
      s0 << r2
      if r2
        r4 = _nt_sqlBoolComparisonOperator
        s0 << r4
        if r4
          s5, i5 = [], index
          loop do
            r6 = _nt_SP
            if r6
              s5 << r6
            else
              break
            end
          end
          r5 = SyntaxNode.new(input, i5...index, s5)
          s0 << r5
          if r5
            r7 = _nt_sqlArithmetic2
            s0 << r7
          end
        end
      end
    end
    if s0.last
      r0 = (SyntaxNode).new(input, i0...index, s0)
      r0.extend(SqlBoolComparison0)
      r0.extend(SqlBoolComparison1)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:sqlBoolComparison][start_index] = r0

    return r0
  end

  def _nt_sqlArithmetic2
    start_index = index
    if node_cache[:sqlArithmetic2].has_key?(index)
      cached = node_cache[:sqlArithmetic2][index]
      @index = cached.interval.end if cached
      return cached
    end

    r0 = _nt_sqlArithmetic

    node_cache[:sqlArithmetic2][start_index] = r0

    return r0
  end

  def _nt_sqlArithmetic3
    start_index = index
    if node_cache[:sqlArithmetic3].has_key?(index)
      cached = node_cache[:sqlArithmetic3][index]
      @index = cached.interval.end if cached
      return cached
    end

    r0 = _nt_sqlArithmetic

    node_cache[:sqlArithmetic3][start_index] = r0

    return r0
  end

  def _nt_sqlArithmetic
    start_index = index
    if node_cache[:sqlArithmetic].has_key?(index)
      cached = node_cache[:sqlArithmetic][index]
      @index = cached.interval.end if cached
      return cached
    end

    r0 = _nt_sqlAdditive

    node_cache[:sqlArithmetic][start_index] = r0

    return r0
  end

  module SqlAdditive0
    def sqlMultiplicative
      elements[0]
    end

    def sqlAdditiveOperator
      elements[2]
    end

    def sqlAdditive
      elements[4]
    end
  end

  module SqlAdditive1
  		def code
  			build {sql_msg(this.sqlMultiplicative.code, this.sqlAdditiveOperator.code, this.sqlAdditive.code)}
  		end
  end

  def _nt_sqlAdditive
    start_index = index
    if node_cache[:sqlAdditive].has_key?(index)
      cached = node_cache[:sqlAdditive][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    i1, s1 = index, []
    r2 = _nt_sqlMultiplicative
    s1 << r2
    if r2
      s3, i3 = [], index
      loop do
        r4 = _nt_SP
        if r4
          s3 << r4
        else
          break
        end
      end
      r3 = SyntaxNode.new(input, i3...index, s3)
      s1 << r3
      if r3
        r5 = _nt_sqlAdditiveOperator
        s1 << r5
        if r5
          s6, i6 = [], index
          loop do
            r7 = _nt_SP
            if r7
              s6 << r7
            else
              break
            end
          end
          r6 = SyntaxNode.new(input, i6...index, s6)
          s1 << r6
          if r6
            r8 = _nt_sqlAdditive
            s1 << r8
          end
        end
      end
    end
    if s1.last
      r1 = (SyntaxNode).new(input, i1...index, s1)
      r1.extend(SqlAdditive0)
      r1.extend(SqlAdditive1)
    else
      self.index = i1
      r1 = nil
    end
    if r1
      r0 = r1
    else
      r9 = _nt_sqlMultiplicative
      if r9
        r0 = r9
      else
        self.index = i0
        r0 = nil
      end
    end

    node_cache[:sqlAdditive][start_index] = r0

    return r0
  end

  module SqlMultiplicative0
    def sqlUnary
      elements[0]
    end

    def sqlMultiplicativeOperator
      elements[2]
    end

    def sqlMultiplicative
      elements[4]
    end
  end

  module SqlMultiplicative1
  		def code
  			build {sql_msg(this.sqlUnary.code, this.sqlMultiplicativeOperator.code, this.sqlMultiplicative.code)}
  		end
  end

  def _nt_sqlMultiplicative
    start_index = index
    if node_cache[:sqlMultiplicative].has_key?(index)
      cached = node_cache[:sqlMultiplicative][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    i1, s1 = index, []
    r2 = _nt_sqlUnary
    s1 << r2
    if r2
      s3, i3 = [], index
      loop do
        r4 = _nt_SP
        if r4
          s3 << r4
        else
          break
        end
      end
      r3 = SyntaxNode.new(input, i3...index, s3)
      s1 << r3
      if r3
        r5 = _nt_sqlMultiplicativeOperator
        s1 << r5
        if r5
          s6, i6 = [], index
          loop do
            r7 = _nt_SP
            if r7
              s6 << r7
            else
              break
            end
          end
          r6 = SyntaxNode.new(input, i6...index, s6)
          s1 << r6
          if r6
            r8 = _nt_sqlMultiplicative
            s1 << r8
          end
        end
      end
    end
    if s1.last
      r1 = (SyntaxNode).new(input, i1...index, s1)
      r1.extend(SqlMultiplicative0)
      r1.extend(SqlMultiplicative1)
    else
      self.index = i1
      r1 = nil
    end
    if r1
      r0 = r1
    else
      r9 = _nt_sqlUnary
      if r9
        r0 = r9
      else
        self.index = i0
        r0 = nil
      end
    end

    node_cache[:sqlMultiplicative][start_index] = r0

    return r0
  end

  module SqlUnary0
    def sqlUnaryOperator
      elements[0]
    end

    def sqlUnary
      elements[2]
    end
  end

  module SqlUnary1
  		def code
  			build {sql_msg(this.sqlUnary.code, this.sqlUnaryOperator.code)}
  		end
  end

  def _nt_sqlUnary
    start_index = index
    if node_cache[:sqlUnary].has_key?(index)
      cached = node_cache[:sqlUnary][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    i1, s1 = index, []
    r2 = _nt_sqlUnaryOperator
    s1 << r2
    if r2
      s3, i3 = [], index
      loop do
        r4 = _nt_SP
        if r4
          s3 << r4
        else
          break
        end
      end
      r3 = SyntaxNode.new(input, i3...index, s3)
      s1 << r3
      if r3
        r5 = _nt_sqlUnary
        s1 << r5
      end
    end
    if s1.last
      r1 = (SyntaxNode).new(input, i1...index, s1)
      r1.extend(SqlUnary0)
      r1.extend(SqlUnary1)
    else
      self.index = i1
      r1 = nil
    end
    if r1
      r0 = r1
    else
      r6 = _nt_sqlFunctionCall
      if r6
        r0 = r6
      else
        self.index = i0
        r0 = nil
      end
    end

    node_cache[:sqlUnary][start_index] = r0

    return r0
  end

  module SqlFunctionCall0
    def sqlFunction
      elements[0]
    end

    def sqlArithmetic
      elements[4]
    end

  end

  module SqlFunctionCall1
  		def code
  			build {sql_msg(this.sqlArithmetic.code, this.sqlFunction.code)}
  		end
  end

  module SqlFunctionCall2
    def sqlFunction
      elements[0]
    end

    def sqlArithmetic
      elements[4]
    end

    def sqlArithmetic2
      elements[8]
    end

  end

  module SqlFunctionCall3
  		def code
  			build {sql_msg(this.sqlArithmetic.code, this.sqlFunction.code, this.sqlArithmetic2.code)}
  		end
  end

  def _nt_sqlFunctionCall
    start_index = index
    if node_cache[:sqlFunctionCall].has_key?(index)
      cached = node_cache[:sqlFunctionCall][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    i1, s1 = index, []
    r2 = _nt_sqlFunction
    s1 << r2
    if r2
      s3, i3 = [], index
      loop do
        r4 = _nt_SP
        if r4
          s3 << r4
        else
          break
        end
      end
      r3 = SyntaxNode.new(input, i3...index, s3)
      s1 << r3
      if r3
        if input.index('(', index) == index
          r5 = (SyntaxNode).new(input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure('(')
          r5 = nil
        end
        s1 << r5
        if r5
          s6, i6 = [], index
          loop do
            r7 = _nt_SP
            if r7
              s6 << r7
            else
              break
            end
          end
          r6 = SyntaxNode.new(input, i6...index, s6)
          s1 << r6
          if r6
            r8 = _nt_sqlArithmetic
            s1 << r8
            if r8
              s9, i9 = [], index
              loop do
                r10 = _nt_SP
                if r10
                  s9 << r10
                else
                  break
                end
              end
              r9 = SyntaxNode.new(input, i9...index, s9)
              s1 << r9
              if r9
                if input.index(')', index) == index
                  r11 = (SyntaxNode).new(input, index...(index + 1))
                  @index += 1
                else
                  terminal_parse_failure(')')
                  r11 = nil
                end
                s1 << r11
                if r11
                  s12, i12 = [], index
                  loop do
                    r13 = _nt_SP
                    if r13
                      s12 << r13
                    else
                      break
                    end
                  end
                  r12 = SyntaxNode.new(input, i12...index, s12)
                  s1 << r12
                end
              end
            end
          end
        end
      end
    end
    if s1.last
      r1 = (SyntaxNode).new(input, i1...index, s1)
      r1.extend(SqlFunctionCall0)
      r1.extend(SqlFunctionCall1)
    else
      self.index = i1
      r1 = nil
    end
    if r1
      r0 = r1
    else
      i14, s14 = index, []
      r15 = _nt_sqlFunction
      s14 << r15
      if r15
        s16, i16 = [], index
        loop do
          r17 = _nt_SP
          if r17
            s16 << r17
          else
            break
          end
        end
        r16 = SyntaxNode.new(input, i16...index, s16)
        s14 << r16
        if r16
          if input.index('(', index) == index
            r18 = (SyntaxNode).new(input, index...(index + 1))
            @index += 1
          else
            terminal_parse_failure('(')
            r18 = nil
          end
          s14 << r18
          if r18
            s19, i19 = [], index
            loop do
              r20 = _nt_SP
              if r20
                s19 << r20
              else
                break
              end
            end
            r19 = SyntaxNode.new(input, i19...index, s19)
            s14 << r19
            if r19
              r21 = _nt_sqlArithmetic
              s14 << r21
              if r21
                s22, i22 = [], index
                loop do
                  r23 = _nt_SP
                  if r23
                    s22 << r23
                  else
                    break
                  end
                end
                r22 = SyntaxNode.new(input, i22...index, s22)
                s14 << r22
                if r22
                  if input.index(',', index) == index
                    r24 = (SyntaxNode).new(input, index...(index + 1))
                    @index += 1
                  else
                    terminal_parse_failure(',')
                    r24 = nil
                  end
                  s14 << r24
                  if r24
                    s25, i25 = [], index
                    loop do
                      r26 = _nt_SP
                      if r26
                        s25 << r26
                      else
                        break
                      end
                    end
                    r25 = SyntaxNode.new(input, i25...index, s25)
                    s14 << r25
                    if r25
                      r27 = _nt_sqlArithmetic2
                      s14 << r27
                      if r27
                        s28, i28 = [], index
                        loop do
                          r29 = _nt_SP
                          if r29
                            s28 << r29
                          else
                            break
                          end
                        end
                        r28 = SyntaxNode.new(input, i28...index, s28)
                        s14 << r28
                        if r28
                          if input.index(')', index) == index
                            r30 = (SyntaxNode).new(input, index...(index + 1))
                            @index += 1
                          else
                            terminal_parse_failure(')')
                            r30 = nil
                          end
                          s14 << r30
                          if r30
                            s31, i31 = [], index
                            loop do
                              r32 = _nt_SP
                              if r32
                                s31 << r32
                              else
                                break
                              end
                            end
                            r31 = SyntaxNode.new(input, i31...index, s31)
                            s14 << r31
                          end
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
      if s14.last
        r14 = (SyntaxNode).new(input, i14...index, s14)
        r14.extend(SqlFunctionCall2)
        r14.extend(SqlFunctionCall3)
      else
        self.index = i14
        r14 = nil
      end
      if r14
        r0 = r14
      else
        r33 = _nt_sqlValue
        if r33
          r0 = r33
        else
          self.index = i0
          r0 = nil
        end
      end
    end

    node_cache[:sqlFunctionCall][start_index] = r0

    return r0
  end

  module SqlFunction0
    def sqlName
      elements[1]
    end

    def EOW
      elements[2]
    end
  end

  module SqlFunction1
  		def code
  			sqlName.code.downcase
  		end
  end

  def _nt_sqlFunction
    start_index = index
    if node_cache[:sqlFunction].has_key?(index)
      cached = node_cache[:sqlFunction][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    if input.index('', index) == index
      r1 = (SyntaxNode).new(input, index...(index + 0))
      @index += 0
    else
      terminal_parse_failure('')
      r1 = nil
    end
    s0 << r1
    if r1
      r2 = _nt_sqlName
      s0 << r2
      if r2
        r3 = _nt_EOW
        s0 << r3
      end
    end
    if s0.last
      r0 = (SyntaxNode).new(input, i0...index, s0)
      r0.extend(SqlFunction0)
      r0.extend(SqlFunction1)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:sqlFunction][start_index] = r0

    return r0
  end

  module SqlValue0
    def sqlArithmetic
      elements[2]
    end

  end

  module SqlValue1
    def code; sqlArithmetic.code; end
  end

  def _nt_sqlValue
    start_index = index
    if node_cache[:sqlValue].has_key?(index)
      cached = node_cache[:sqlValue][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    i1, s1 = index, []
    if input.index('(', index) == index
      r2 = (SyntaxNode).new(input, index...(index + 1))
      @index += 1
    else
      terminal_parse_failure('(')
      r2 = nil
    end
    s1 << r2
    if r2
      s3, i3 = [], index
      loop do
        r4 = _nt_SP
        if r4
          s3 << r4
        else
          break
        end
      end
      r3 = SyntaxNode.new(input, i3...index, s3)
      s1 << r3
      if r3
        r5 = _nt_sqlArithmetic
        s1 << r5
        if r5
          s6, i6 = [], index
          loop do
            r7 = _nt_SP
            if r7
              s6 << r7
            else
              break
            end
          end
          r6 = SyntaxNode.new(input, i6...index, s6)
          s1 << r6
          if r6
            if input.index(')', index) == index
              r8 = (SyntaxNode).new(input, index...(index + 1))
              @index += 1
            else
              terminal_parse_failure(')')
              r8 = nil
            end
            s1 << r8
          end
        end
      end
    end
    if s1.last
      r1 = (SyntaxNode).new(input, i1...index, s1)
      r1.extend(SqlValue0)
      r1.extend(SqlValue1)
    else
      self.index = i1
      r1 = nil
    end
    if r1
      r0 = r1
    else
      r9 = _nt_sqlLiteral
      if r9
        r0 = r9
      else
        r10 = _nt_sqlRef
        if r10
          r0 = r10
        else
          self.index = i0
          r0 = nil
        end
      end
    end

    node_cache[:sqlValue][start_index] = r0

    return r0
  end

  module SqlRef0
    def sqlTable
      elements[0]
    end

    def sqlColumn
      elements[2]
    end
  end

  module SqlRef1
    	def code
    		build {sql_ref(this.sqlColumn.code, this.sqlTable.code)}
    	end
  end

  module SqlRef2
    def sqlColumn2
      elements[1]
    end
  end

  module SqlRef3
    	def code
    		build {sql_ref(this.sqlColumn2.code)}
    	end
  end

  def _nt_sqlRef
    start_index = index
    if node_cache[:sqlRef].has_key?(index)
      cached = node_cache[:sqlRef][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    i1, s1 = index, []
    r2 = _nt_sqlTable
    s1 << r2
    if r2
      if input.index('.', index) == index
        r3 = (SyntaxNode).new(input, index...(index + 1))
        @index += 1
      else
        terminal_parse_failure('.')
        r3 = nil
      end
      s1 << r3
      if r3
        r4 = _nt_sqlColumn
        s1 << r4
      end
    end
    if s1.last
      r1 = (SyntaxNode).new(input, i1...index, s1)
      r1.extend(SqlRef0)
      r1.extend(SqlRef1)
    else
      self.index = i1
      r1 = nil
    end
    if r1
      r0 = r1
    else
      i5, s5 = index, []
      if input.index('', index) == index
        r6 = (SyntaxNode).new(input, index...(index + 0))
        @index += 0
      else
        terminal_parse_failure('')
        r6 = nil
      end
      s5 << r6
      if r6
        r7 = _nt_sqlColumn2
        s5 << r7
      end
      if s5.last
        r5 = (SyntaxNode).new(input, i5...index, s5)
        r5.extend(SqlRef2)
        r5.extend(SqlRef3)
      else
        self.index = i5
        r5 = nil
      end
      if r5
        r0 = r5
      else
        self.index = i0
        r0 = nil
      end
    end

    node_cache[:sqlRef][start_index] = r0

    return r0
  end

  module SqlTable0
    def sqlName
      elements[1]
    end

  end

  module SqlTable1
    def code; sqlName.code; end
  end

  def _nt_sqlTable
    start_index = index
    if node_cache[:sqlTable].has_key?(index)
      cached = node_cache[:sqlTable][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    i1, s1 = index, []
    if input.index('"', index) == index
      r2 = (SyntaxNode).new(input, index...(index + 1))
      @index += 1
    else
      terminal_parse_failure('"')
      r2 = nil
    end
    s1 << r2
    if r2
      r3 = _nt_sqlName
      s1 << r3
      if r3
        if input.index('"', index) == index
          r4 = (SyntaxNode).new(input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure('"')
          r4 = nil
        end
        s1 << r4
      end
    end
    if s1.last
      r1 = (SyntaxNode).new(input, i1...index, s1)
      r1.extend(SqlTable0)
      r1.extend(SqlTable1)
    else
      self.index = i1
      r1 = nil
    end
    if r1
      r0 = r1
    else
      r5 = _nt_sqlName
      if r5
        r0 = r5
      else
        self.index = i0
        r0 = nil
      end
    end

    node_cache[:sqlTable][start_index] = r0

    return r0
  end

  def _nt_sqlColumn2
    start_index = index
    if node_cache[:sqlColumn2].has_key?(index)
      cached = node_cache[:sqlColumn2][index]
      @index = cached.interval.end if cached
      return cached
    end

    r0 = _nt_sqlColumn

    node_cache[:sqlColumn2][start_index] = r0

    return r0
  end

  module SqlColumn0
    def sqlName
      elements[1]
    end

  end

  module SqlColumn1
    def code; sqlName.code; end
  end

  def _nt_sqlColumn
    start_index = index
    if node_cache[:sqlColumn].has_key?(index)
      cached = node_cache[:sqlColumn][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    i1, s1 = index, []
    if input.index('"', index) == index
      r2 = (SyntaxNode).new(input, index...(index + 1))
      @index += 1
    else
      terminal_parse_failure('"')
      r2 = nil
    end
    s1 << r2
    if r2
      r3 = _nt_sqlName
      s1 << r3
      if r3
        if input.index('"', index) == index
          r4 = (SyntaxNode).new(input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure('"')
          r4 = nil
        end
        s1 << r4
      end
    end
    if s1.last
      r1 = (SyntaxNode).new(input, i1...index, s1)
      r1.extend(SqlColumn0)
      r1.extend(SqlColumn1)
    else
      self.index = i1
      r1 = nil
    end
    if r1
      r0 = r1
    else
      r5 = _nt_sqlName
      if r5
        r0 = r5
      else
        self.index = i0
        r0 = nil
      end
    end

    node_cache[:sqlColumn][start_index] = r0

    return r0
  end

  module SqlName0
  end

  module SqlName1
    def code; text_value; end
  end

  def _nt_sqlName
    start_index = index
    if node_cache[:sqlName].has_key?(index)
      cached = node_cache[:sqlName][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    if input.index(Regexp.new('[a-zA-Z_]'), index) == index
      r1 = (SyntaxNode).new(input, index...(index + 1))
      @index += 1
    else
      r1 = nil
    end
    s0 << r1
    if r1
      s2, i2 = [], index
      loop do
        if input.index(Regexp.new('[a-zA-Z0-9_]'), index) == index
          r3 = (SyntaxNode).new(input, index...(index + 1))
          @index += 1
        else
          r3 = nil
        end
        if r3
          s2 << r3
        else
          break
        end
      end
      r2 = SyntaxNode.new(input, i2...index, s2)
      s0 << r2
    end
    if s0.last
      r0 = (SyntaxNode).new(input, i0...index, s0)
      r0.extend(SqlName0)
      r0.extend(SqlName1)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:sqlName][start_index] = r0

    return r0
  end

  def _nt_SP
    start_index = index
    if node_cache[:SP].has_key?(index)
      cached = node_cache[:SP][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    if input.index(" ", index) == index
      r1 = (SyntaxNode).new(input, index...(index + 1))
      @index += 1
    else
      terminal_parse_failure(" ")
      r1 = nil
    end
    if r1
      r0 = r1
    else
      if input.index("\n", index) == index
        r2 = (SyntaxNode).new(input, index...(index + 1))
        @index += 1
      else
        terminal_parse_failure("\n")
        r2 = nil
      end
      if r2
        r0 = r2
      else
        if input.index("\t", index) == index
          r3 = (SyntaxNode).new(input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure("\t")
          r3 = nil
        end
        if r3
          r0 = r3
        else
          if input.index("\r", index) == index
            r4 = (SyntaxNode).new(input, index...(index + 1))
            @index += 1
          else
            terminal_parse_failure("\r")
            r4 = nil
          end
          if r4
            r0 = r4
          else
            self.index = i0
            r0 = nil
          end
        end
      end
    end

    node_cache[:SP][start_index] = r0

    return r0
  end

  def _nt_EOW
    start_index = index
    if node_cache[:EOW].has_key?(index)
      cached = node_cache[:EOW][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    if input.index(Regexp.new('[a-zA-Z0-9_]'), index) == index
      r1 = (SyntaxNode).new(input, index...(index + 1))
      @index += 1
    else
      r1 = nil
    end
    if r1
      r0 = nil
    else
      self.index = i0
      r0 = SyntaxNode.new(input, index...index)
    end

    node_cache[:EOW][start_index] = r0

    return r0
  end

  module EOWSP0
  end

  def _nt_EOWSP
    start_index = index
    if node_cache[:EOWSP].has_key?(index)
      cached = node_cache[:EOWSP][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    i1 = index
    if input.index(Regexp.new('[a-zA-Z0-9_]'), index) == index
      r2 = (SyntaxNode).new(input, index...(index + 1))
      @index += 1
    else
      r2 = nil
    end
    if r2
      r1 = nil
    else
      self.index = i1
      r1 = SyntaxNode.new(input, index...index)
    end
    s0 << r1
    if r1
      s3, i3 = [], index
      loop do
        r4 = _nt_SP
        if r4
          s3 << r4
        else
          break
        end
      end
      r3 = SyntaxNode.new(input, i3...index, s3)
      s0 << r3
    end
    if s0.last
      r0 = (SyntaxNode).new(input, i0...index, s0)
      r0.extend(EOWSP0)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:EOWSP][start_index] = r0

    return r0
  end

  def _nt_sqlLiteral
    start_index = index
    if node_cache[:sqlLiteral].has_key?(index)
      cached = node_cache[:sqlLiteral][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    r1 = _nt_sqlStringLiteral
    if r1
      r0 = r1
    else
      r2 = _nt_sqlNumberLiteral
      if r2
        r0 = r2
      else
        self.index = i0
        r0 = nil
      end
    end

    node_cache[:sqlLiteral][start_index] = r0

    return r0
  end

  module SqlStringLiteral0
    def sqlStringLiteralInsideQuotes
      elements[1]
    end

  end

  module SqlStringLiteral1
     	def code
     		sqlStringLiteralInsideQuotes.code
     	end
  end

  def _nt_sqlStringLiteral
    start_index = index
    if node_cache[:sqlStringLiteral].has_key?(index)
      cached = node_cache[:sqlStringLiteral][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    if input.index(Regexp.new('[\']'), index) == index
      r1 = (SyntaxNode).new(input, index...(index + 1))
      @index += 1
    else
      r1 = nil
    end
    s0 << r1
    if r1
      r2 = _nt_sqlStringLiteralInsideQuotes
      s0 << r2
      if r2
        if input.index(Regexp.new('[\']'), index) == index
          r3 = (SyntaxNode).new(input, index...(index + 1))
          @index += 1
        else
          r3 = nil
        end
        s0 << r3
      end
    end
    if s0.last
      r0 = (SyntaxNode).new(input, i0...index, s0)
      r0.extend(SqlStringLiteral0)
      r0.extend(SqlStringLiteral1)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:sqlStringLiteral][start_index] = r0

    return r0
  end

  module SqlStringLiteralInsideQuotes0
  end

  module SqlStringLiteralInsideQuotes1
    def code; text_value; end
  end

  def _nt_sqlStringLiteralInsideQuotes
    start_index = index
    if node_cache[:sqlStringLiteralInsideQuotes].has_key?(index)
      cached = node_cache[:sqlStringLiteralInsideQuotes][index]
      @index = cached.interval.end if cached
      return cached
    end

    s0, i0 = [], index
    loop do
      i1, s1 = index, []
      i2 = index
      if input.index("'", index) == index
        r3 = (SyntaxNode).new(input, index...(index + 1))
        @index += 1
      else
        terminal_parse_failure("'")
        r3 = nil
      end
      if r3
        r2 = nil
      else
        self.index = i2
        r2 = SyntaxNode.new(input, index...index)
      end
      s1 << r2
      if r2
        if index < input_length
          r4 = (SyntaxNode).new(input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure("any character")
          r4 = nil
        end
        s1 << r4
      end
      if s1.last
        r1 = (SyntaxNode).new(input, i1...index, s1)
        r1.extend(SqlStringLiteralInsideQuotes0)
      else
        self.index = i1
        r1 = nil
      end
      if r1
        s0 << r1
      else
        break
      end
    end
    r0 = SyntaxNode.new(input, i0...index, s0)
    r0.extend(SqlStringLiteralInsideQuotes1)

    node_cache[:sqlStringLiteralInsideQuotes][start_index] = r0

    return r0
  end

  def _nt_sqlNumberLiteral
    start_index = index
    if node_cache[:sqlNumberLiteral].has_key?(index)
      cached = node_cache[:sqlNumberLiteral][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    r1 = _nt_sqlFloatLiteral
    if r1
      r0 = r1
    else
      r2 = _nt_sqlIntegerLiteral
      if r2
        r0 = r2
      else
        self.index = i0
        r0 = nil
      end
    end

    node_cache[:sqlNumberLiteral][start_index] = r0

    return r0
  end

  module SqlIntegerLiteral0
    def code; text_value.to_i; end
  end

  def _nt_sqlIntegerLiteral
    start_index = index
    if node_cache[:sqlIntegerLiteral].has_key?(index)
      cached = node_cache[:sqlIntegerLiteral][index]
      @index = cached.interval.end if cached
      return cached
    end

    s0, i0 = [], index
    loop do
      if input.index(Regexp.new('[0-9]'), index) == index
        r1 = (SyntaxNode).new(input, index...(index + 1))
        @index += 1
      else
        r1 = nil
      end
      if r1
        s0 << r1
      else
        break
      end
    end
    if s0.empty?
      self.index = i0
      r0 = nil
    else
      r0 = SyntaxNode.new(input, i0...index, s0)
      r0.extend(SqlIntegerLiteral0)
    end

    node_cache[:sqlIntegerLiteral][start_index] = r0

    return r0
  end

  module SqlFloatLiteral0
    def sqlIntegerLiteral
      elements[2]
    end
  end

  module SqlFloatLiteral1
    def sqlIntegerLiteral
      elements[0]
    end

    def sqlIntegerLiteral
      elements[2]
    end

  end

  module SqlFloatLiteral2
  		def code; text_value.to_f; end
  end

  def _nt_sqlFloatLiteral
    start_index = index
    if node_cache[:sqlFloatLiteral].has_key?(index)
      cached = node_cache[:sqlFloatLiteral][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    r1 = _nt_sqlIntegerLiteral
    s0 << r1
    if r1
      if input.index('.', index) == index
        r2 = (SyntaxNode).new(input, index...(index + 1))
        @index += 1
      else
        terminal_parse_failure('.')
        r2 = nil
      end
      s0 << r2
      if r2
        r3 = _nt_sqlIntegerLiteral
        s0 << r3
        if r3
          i5, s5 = index, []
          if input.index(Regexp.new('[eE]'), index) == index
            r6 = (SyntaxNode).new(input, index...(index + 1))
            @index += 1
          else
            r6 = nil
          end
          s5 << r6
          if r6
            r8 = _nt_sqlUnaryOperator
            if r8
              r7 = r8
            else
              r7 = SyntaxNode.new(input, index...index)
            end
            s5 << r7
            if r7
              r9 = _nt_sqlIntegerLiteral
              s5 << r9
            end
          end
          if s5.last
            r5 = (SyntaxNode).new(input, i5...index, s5)
            r5.extend(SqlFloatLiteral0)
          else
            self.index = i5
            r5 = nil
          end
          if r5
            r4 = r5
          else
            r4 = SyntaxNode.new(input, index...index)
          end
          s0 << r4
        end
      end
    end
    if s0.last
      r0 = (SyntaxNode).new(input, i0...index, s0)
      r0.extend(SqlFloatLiteral1)
      r0.extend(SqlFloatLiteral2)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:sqlFloatLiteral][start_index] = r0

    return r0
  end

  module SqlUnaryOperator0
    def code; text_value; end
  end

  def _nt_sqlUnaryOperator
    start_index = index
    if node_cache[:sqlUnaryOperator].has_key?(index)
      cached = node_cache[:sqlUnaryOperator][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    if input.index('-', index) == index
      r1 = (SyntaxNode).new(input, index...(index + 1))
      @index += 1
    else
      terminal_parse_failure('-')
      r1 = nil
    end
    if r1
      r0 = r1
      r0.extend(SqlUnaryOperator0)
    else
      if input.index('+', index) == index
        r2 = (SyntaxNode).new(input, index...(index + 1))
        @index += 1
      else
        terminal_parse_failure('+')
        r2 = nil
      end
      if r2
        r0 = r2
        r0.extend(SqlUnaryOperator0)
      else
        self.index = i0
        r0 = nil
      end
    end

    node_cache[:sqlUnaryOperator][start_index] = r0

    return r0
  end

  module SqlAdditiveOperator0
	def code; text_value; end
  end

  def _nt_sqlAdditiveOperator
    start_index = index
    if node_cache[:sqlAdditiveOperator].has_key?(index)
      cached = node_cache[:sqlAdditiveOperator][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    if input.index('-', index) == index
      r1 = (SyntaxNode).new(input, index...(index + 1))
      @index += 1
    else
      terminal_parse_failure('-')
      r1 = nil
    end
    if r1
      r0 = r1
      r0.extend(SqlAdditiveOperator0)
    else
      if input.index('+', index) == index
        r2 = (SyntaxNode).new(input, index...(index + 1))
        @index += 1
      else
        terminal_parse_failure('+')
        r2 = nil
      end
      if r2
        r0 = r2
        r0.extend(SqlAdditiveOperator0)
      else
        if input.index('||', index) == index
          r3 = (SyntaxNode).new(input, index...(index + 2))
          @index += 2
        else
          terminal_parse_failure('||')
          r3 = nil
        end
        if r3
          r0 = r3
          r0.extend(SqlAdditiveOperator0)
        else
          self.index = i0
          r0 = nil
        end
      end
    end

    node_cache[:sqlAdditiveOperator][start_index] = r0

    return r0
  end

  module SqlMultiplicativeOperator0
	def code; text_value; end
  end

  def _nt_sqlMultiplicativeOperator
    start_index = index
    if node_cache[:sqlMultiplicativeOperator].has_key?(index)
      cached = node_cache[:sqlMultiplicativeOperator][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    if input.index('*', index) == index
      r1 = (SyntaxNode).new(input, index...(index + 1))
      @index += 1
    else
      terminal_parse_failure('*')
      r1 = nil
    end
    if r1
      r0 = r1
      r0.extend(SqlMultiplicativeOperator0)
    else
      if input.index('/', index) == index
        r2 = (SyntaxNode).new(input, index...(index + 1))
        @index += 1
      else
        terminal_parse_failure('/')
        r2 = nil
      end
      if r2
        r0 = r2
        r0.extend(SqlMultiplicativeOperator0)
      else
        self.index = i0
        r0 = nil
      end
    end

    node_cache[:sqlMultiplicativeOperator][start_index] = r0

    return r0
  end

  module SqlBoolComparisonOperator0
  end

  module SqlBoolComparisonOperator1
  		def code; text_value.downcase; end
  end

  def _nt_sqlBoolComparisonOperator
    start_index = index
    if node_cache[:sqlBoolComparisonOperator].has_key?(index)
      cached = node_cache[:sqlBoolComparisonOperator][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    if input.index('=', index) == index
      r1 = (SyntaxNode).new(input, index...(index + 1))
      @index += 1
    else
      terminal_parse_failure('=')
      r1 = nil
    end
    if r1
      r0 = r1
      r0.extend(SqlBoolComparisonOperator1)
    else
      if input.index('!=', index) == index
        r2 = (SyntaxNode).new(input, index...(index + 2))
        @index += 2
      else
        terminal_parse_failure('!=')
        r2 = nil
      end
      if r2
        r0 = r2
        r0.extend(SqlBoolComparisonOperator1)
      else
        if input.index('>=', index) == index
          r3 = (SyntaxNode).new(input, index...(index + 2))
          @index += 2
        else
          terminal_parse_failure('>=')
          r3 = nil
        end
        if r3
          r0 = r3
          r0.extend(SqlBoolComparisonOperator1)
        else
          if input.index('<=', index) == index
            r4 = (SyntaxNode).new(input, index...(index + 2))
            @index += 2
          else
            terminal_parse_failure('<=')
            r4 = nil
          end
          if r4
            r0 = r4
            r0.extend(SqlBoolComparisonOperator1)
          else
            if input.index('<>', index) == index
              r5 = (SyntaxNode).new(input, index...(index + 2))
              @index += 2
            else
              terminal_parse_failure('<>')
              r5 = nil
            end
            if r5
              r0 = r5
              r0.extend(SqlBoolComparisonOperator1)
            else
              if input.index('>', index) == index
                r6 = (SyntaxNode).new(input, index...(index + 1))
                @index += 1
              else
                terminal_parse_failure('>')
                r6 = nil
              end
              if r6
                r0 = r6
                r0.extend(SqlBoolComparisonOperator1)
              else
                if input.index('<', index) == index
                  r7 = (SyntaxNode).new(input, index...(index + 1))
                  @index += 1
                else
                  terminal_parse_failure('<')
                  r7 = nil
                end
                if r7
                  r0 = r7
                  r0.extend(SqlBoolComparisonOperator1)
                else
                  i8, s8 = index, []
                  if input.index(Regexp.new('[lL]'), index) == index
                    r9 = (SyntaxNode).new(input, index...(index + 1))
                    @index += 1
                  else
                    r9 = nil
                  end
                  s8 << r9
                  if r9
                    if input.index(Regexp.new('[iI]'), index) == index
                      r10 = (SyntaxNode).new(input, index...(index + 1))
                      @index += 1
                    else
                      r10 = nil
                    end
                    s8 << r10
                    if r10
                      if input.index(Regexp.new('[kK]'), index) == index
                        r11 = (SyntaxNode).new(input, index...(index + 1))
                        @index += 1
                      else
                        r11 = nil
                      end
                      s8 << r11
                      if r11
                        if input.index(Regexp.new('[eE]'), index) == index
                          r12 = (SyntaxNode).new(input, index...(index + 1))
                          @index += 1
                        else
                          r12 = nil
                        end
                        s8 << r12
                      end
                    end
                  end
                  if s8.last
                    r8 = (SyntaxNode).new(input, i8...index, s8)
                    r8.extend(SqlBoolComparisonOperator0)
                  else
                    self.index = i8
                    r8 = nil
                  end
                  if r8
                    r0 = r8
                    r0.extend(SqlBoolComparisonOperator1)
                  else
                    self.index = i0
                    r0 = nil
                  end
                end
              end
            end
          end
        end
      end
    end

    node_cache[:sqlBoolComparisonOperator][start_index] = r0

    return r0
  end

end

class FindConditionsSqlSyntaxParser < Treetop::Runtime::CompiledParser
  include FindConditionsSqlSyntax
end
