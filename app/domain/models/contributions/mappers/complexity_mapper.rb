# frozen_string_literal: true

module CodePraise
  module Mapper
    # Transform Flog raw data into Complexity Entity
    class Complexity
      def initialize(file_path)
        @file_path = file_path
      end

      def build_entity
        complexity = abc_metric

        return nil if complexity.nil?

        Entity::Complexity.new(
          average: complexity[:average],
          methods: complexity[:methods]
        )
      end

      private

      def abc_metric
        abc_metric = CodePraise::Complexity::AbcMetric.new(@file_path)
        CodePraise::Complexity::Calculator.new(abc_metric).calculate
      end
    end
  end
end