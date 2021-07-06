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
        flog = CodePraise::Complexity::FlogReporter.new(@file_path)
        flog.report
      end
    end
  end
end