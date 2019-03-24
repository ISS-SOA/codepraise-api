require 'roar/decorator'
require 'roar/json'

module CodePraise
  module Representer
    # Represents folder summary about repo's folder
    class MethodComplexityRepresenter < Roar::Decorator
      include Roar::JSON

      property :name
      property :complexity
    end
  end
end
