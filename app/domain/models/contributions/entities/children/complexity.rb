# frozen_string_literal: true

module CodePraise
  module Entity
    # Complexity for file and methods of this file
    class Complexity
      attr_reader :average, :methods

      def initialize(average:, methods:)
        @average = average
        @methods = methods
      end
    end
  end
end
