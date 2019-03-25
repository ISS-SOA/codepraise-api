# frozen_string_literal: true

require 'parser/current'
require 'unparser'


module CodePraise

  module Measurement

    module NumberOfMethod

      def self.calculate(contributions)
        ast = Parser::CurrentRuby.parse(code(contributions))
        all_methods(ast, contributions)
      end

      private

      def self.code(contributions)
        contributions.map(&:code).join("\n")
      end


      def self.all_methods(ast, contributions)
        methods = []
        find_methods(ast, methods)
        return [] if methods.empty?
        methods.inject([]) do |result, method_ast|
          result.push({
            name: method_name(method_ast),
            lines: line_contribution(method_ast, contributions)
          })
        end
      end

      def self.line_contribution(method_ast, contributions)
        method_code_array = Unparser.unparse(method_ast).split("\n")
        first_number = contributions.select {|loc| loc.code.strip == method_code_array[0].strip}[0].number
        end_number = first_number + method_code_array.count - 1
        result = []
        while first_number <= end_number
          loc = contributions.select {|loc| loc.number == first_number}[0]
          first_number +=1
          result.push(loc)
          break if loc.nil?
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

      def self.find_methods(ast, methods)
        return nil unless Parser::AST::Node === ast
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