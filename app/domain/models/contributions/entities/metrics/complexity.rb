# frozen_string_literal: true

module CodePraise

  module Entity

    class Complexity

      attr_reader :average, :methods_complexity

      def initialize(average: ,methods_complexity: )
        @average = average
        @methods_complexity = methods_complexity
      end
    end
  end
end
