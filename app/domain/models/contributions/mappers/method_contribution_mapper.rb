# frozen_string_literal: true

module CodePraise
  module Mapper
    class MethodContributions
      def initialize(file_contributions)
        @file_contributions = file_contributions
      end

      def build_entity
        methods = all_methods

        return nil if methods.nil?

        methods.map do |method|
          Entity::MethodContribution.new(
            name: method[:name],
            lines: method[:lines]
          )
        end
      end

      private

      def all_methods
        MethodParser.parse_methods(@file_contributions)
      end
    end
  end
end