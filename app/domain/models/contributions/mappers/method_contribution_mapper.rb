require 'parser/current'
require 'unparser'


module CodePraise

  module Mapper

    class MethodContributions
      def initialize(file_code)
        @file_code =  file_code[:file_code]
        @codes = @file_code.map(&:code).join("\n")
        @ast = Parser::CurrentRuby.parse(@codes)
      end

      def build_entity
        all_methods.map do |method|
          Entity::MethodContribution.new(
            name: method[:name],
            lines: method[:lines]
          )
        end
      end

      private

      def all_methods
        methods = []
        find_methods(@ast, methods)
        return [] if methods.empty?
        methods.inject([]) do |result, method|
          result.push({
            name: method_name(method),
            lines: line_contribution(method)
          })
        end
      end

      def line_contribution(method)
        method_codes = Unparser.unparse(method).split("\n")
        first_no = @file_code.select {|loc| loc.code.strip == method_codes[0].strip}[0].number
        end_no = first_no + method_codes.count - 1
        result = []
        while first_no <= end_no
          loc = @file_code.select {|loc| loc.number == first_no}[0]
          first_no +=1
          result.push(loc)
          break if loc.nil?
          end_no += 1 if loc.code.strip.empty?
        end
        result
      end


      def method_name(ast)
        if ast.type == :block
          return ast.children[0].children[1]
        elsif ast.type == :def
          return ast.children[0]
        end
      end

      def find_methods(ast, methods)
        return unless Parser::AST::Node === ast
        if ast.type == :def
          methods.append(ast)
        else
          ast.children.each do |ast|
            find_methods(ast, methods)
          end
        end
      end
    end
  end
end