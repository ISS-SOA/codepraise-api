# frozen_string_literal: true

require 'parser/current'
require 'unparser'


module CodePraise

  module Measurement

    module NumberOfMethod

      def self.calculate(line_entities)
        ast = Parser::CurrentRuby.parse(line_of_code(line_entities))
        all_methods_hash(ast, line_entities)
      end

      private

      def self.line_of_code(line_entities)
        line_entities.map(&:code).join("\n")
      end


      def self.all_methods_hash(ast, line_entities)
        methods_ast = []
        find_methods_tree(ast, methods_ast)
        return [] if methods_ast.empty?
        methods_ast.inject([]) do |result, method_ast|
          result.push({
            name: method_name(method_ast),
            lines: select_entity(method_ast, line_entities)
          })
        end
      end

      def self.select_entity(method_ast, line_entities)
        method_loc = Unparser.unparse(method_ast).split("\n")
        first_number = line_entities.select {|loc| loc.code.strip == method_loc[0].strip}[0].number
        end_number = first_number + method_loc.count - 1
        result = []
        while first_number <= end_number
          loc = line_entities.select {|loc| loc.number == first_number}[0]
          break if loc.nil?
          first_number +=1
          result.push(loc)
          end_number += 1 if blank_line?(loc) || comment?(loc)
        end
        result
      end

      def self.blank_line?(loc)
        loc.code.strip.empty?
      end

      def self.comment?(loc)
        loc.code.strip[0] == '#'
      end

      def self.method_name(method_ast)
        method_ast.children[0]
      end

      def self.find_methods_tree(ast, methods_ast)
        return nil unless Parser::AST::Node === ast
        if ast.type == :def
          methods_ast.append(ast)
        else
          ast.children.each do |ast|
            find_methods_tree(ast, methods_ast)
          end
        end
      end

    end
  end
end