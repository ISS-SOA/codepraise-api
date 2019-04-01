require 'roar/decorator'
require 'roar/json'

module CodePraise
  module Representer
    # Represents folder summary about repo's folder
    class Complexity < Roar::Decorator
      include Roar::JSON

      property :average
      property :methods
    end
  end
end
