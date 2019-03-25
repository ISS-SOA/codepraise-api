require_relative '../lib/measurement/number_of_method'

module CodePraise

  module Mapper

    class MethodContributions
      def initialize(file_contributions)
        @file_contributions = file_contributions
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
        Measurement::NumberOfMethod.calculate(@file_contributions)
      end
    end
  end
end