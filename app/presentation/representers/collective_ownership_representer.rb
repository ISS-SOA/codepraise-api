require 'roar/decorator'
require 'roar/json'


module CodePraise
  module Representer
    # Represents folder summary about repo's folder
    class CollectiveOwnership < Roar::Decorator
      include Roar::JSON

      property :contributor
      collection :contributions
      property :coefficient_variation
    end
  end
end
