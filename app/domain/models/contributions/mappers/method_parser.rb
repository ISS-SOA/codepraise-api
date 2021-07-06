# frozen_string_literal: true

require 'parser/current'
require 'unparser'

module CodePraise
  module Mapper
    # Find all method in a file
    module MethodParser
      def self.parse_methods(line_entities)
        ast = Parser::CurrentRuby.parse(line_of_code(line_entities))
        all_methods_hash(ast, line_entities)
      end

      def self.line_of_code(line_entities)
        line_entities.map(&:code).join("\n")
      end

      def self.all_methods_hash(ast, line_entities)
        methods_ast = []
        find_methods_tree(ast, methods_ast)

        return nil if methods_ast.empty?

        methods_ast.inject([]) do |result, method_ast|
          result.push(name: method_name(method_ast),
                      lines: select_entities(method_ast, line_entities))
        end
      end

      def self.select_entities(method_ast, line_entities)
        method_name = method_name(method_ast)
        end_amount = count_end(method_ast)

        number = line_entities.select do |line_entity|
          line_entity.code.include?("def #{method_name}")
        end.first.number

        method_entities = []

        while end_amount.positive?
          line_entity = select_entity(line_entities, number)

          break if line_entity.nil?

          end_amount -= 1 if end_entity?(line_entity)
          number += 1
          method_entities << line_entity
        end

        method_entities
      end

      private

      def self.select_entity(line_entities, number)
        line_entities.select do |line_entity|
          line_entity.number == number
        end.first
      end

      def self.end_entity?(line_entity)
        line_entity.code.strip == 'end'
      end

      def self.count_end(method_ast)
        method_lines = Unparser.unparse(method_ast)
        method_lines.scan(/end/).count
      end

      def self.method_name(method_ast)
        method_ast.children[0].to_s
      end

      def self.find_methods_tree(ast, methods_ast)
        return nil unless ast.is_a?(Parser::AST::Node)

        if ast.type == :def
          methods_ast.append(ast)
        else
          ast.children.each do |child_ast|
            find_methods_tree(child_ast, methods_ast)
          end
        end
      end

      private_class_method :find_methods_tree, :count_end,
                           :method_name, :select_entity, :end_entity?
    end
  end
end
