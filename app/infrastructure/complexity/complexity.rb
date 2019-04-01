# frozen_string_literal: true

module CodePraise
  module Complexity
    # Complexity Calculator
    class Calculator
      def initialize(adapter)
        @adapter = adapter
      end

      def calculate
        @adapter.calculate
      end
    end
  end
end
