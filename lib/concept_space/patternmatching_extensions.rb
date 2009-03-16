#TODO Submit PatternMacthing Extensions
#TODO Equality of reused variables
#TODO symbols from childless nodes
module PatternMatching
  class Node
    def inspect
        "#{@name}(#{@children.collect {|x| x.inspect}.join(' ,')})"
    end
    def == (other)
      return false unless self.class === other
      return false unless @name == other.name
      return false unless size == other.size
      (0...size).each {|i| 
        return false unless self[i] == other[i]}
      return true
    end
  end

  class MatchExec
    class InstanceVariableAccessor
      def method_missing(name, *args)
        begin
          @receiver.send(name, *args)
        rescue NameError
          if name.to_s[-1,1] == "="
            field = "@" + name.to_s[0...-1]
            @receiver.instance_variable_set(field, args[0])
          else
            field = "@" + name.to_s
            @receiver.instance_variable_get(field)
          end
        end
      end
    end

    class ExecuteAs
      def build &block
#          PatternMatching.build &block
           FuncNodeBuilder.new(@args, @receiver).instance_eval(&block)
      end
      class FuncNodeBuilder
        def initialize(args, receiver)
          @receiver = receiver
          @wrapper = InstanceVariableAccessor.new receiver
          @args = args
        end
        def this
          @receiver
        end
        def the
          @wrapper
        end

        def method_missing(name, *method_args)          
          return @args[name] if @args.key?(name)
          Node.new(name, method_args)
        end        
      end
    end
  end
end
