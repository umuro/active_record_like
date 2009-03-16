require 'rubygems'
require 'fileutils'
require 'treetop'
#TODO Add patternmatching to README:Requirements and parent project

module Treetop
  module Runtime
    class SyntaxNode
      def build &block
#        PatternMatching.build &block
        PatternMatching::MatchExec::ExecuteAs::FuncNodeBuilder.new({}, self).instance_eval(&block)
      end
    end
  end
end

module ConceptSpace
  module ActiveRecordLike
    module Adapter
      module Parser
        
class GrammarBuilder
  extend PatternMatching

  class Maker
     def initialize klass_dir, grammar_file, parser_class_name
        @klass_dir = klass_dir
        @grammar_file = grammar_file
        @parser_class_name  = parser_class_name
     end

    def grammarTarget
      @grammar_file[0...-(File.extname(@grammar_file)).size] + '.rb'
    end
    def touchSource
      FileUtils.touch @grammar_file
    end
    def removeTarget
      FileUtils.rm grammarTarget if File.exists? grammarTarget
    end
    def uptodate?
      target = grammarTarget
      sources = [@grammar_file]
      FileUtils.uptodate? target, sources
    end
    def update
      removeTarget
      output = `cd #{@klass_dir}; tt #{@grammar_file}`
      raise output if $? && $?.exitstatus != 0
      loadGrammarTarget
    end
    def loadGrammarTarget
      load(grammarTarget)
#      Treetop::Runtime::SyntaxNode.extend PatternMatching
    end

    def parser
      update unless uptodate?
      begin
        @parser_class_name.constantize
      rescue NameError
           loadGrammarTarget
      end
      @parser_class_name.constantize.new
    end

  end#class Maker
  class << self
    def klass_dir
      File.dirname(__FILE__)
    end
    def maker
        @maker ||= Maker.new klass_dir,  grammar_file, parser_klass_name
    end    
    def parse conditions_string
      the_parser = maker.parser
      answer = the_parser.parse conditions_string
      unless answer
        errors = "FindConditions.parse: \n"
        the_parser.terminal_failures.each do | f |
          errors << "Expected: #{f.expected_string} "
          errors <<  "At: #{the_parser.input[0...(f.index+1)]}<-- "
          errors << "\n"
        end
        Rails.logger.fatal errors
        raise errors
      else
        answer
      end
    end 
  end #class << self

    def convert_parse conditions_string
      answer = self.class.parse(conditions_string)
      convert answer.code
    end    
    
end #class

      end
    end
  end
end