
module CodePraise
  module Entity

    class CollectiveOwnership

      attr_reader :contributor, :coefficient_variation, :contributions

      def initialize(contributor:, coefficient_variation:, contributions:)
        @contributor = contributor
        @coefficient_variation = coefficient_variation
        @contributions = contributions
      end
    end
  end
end