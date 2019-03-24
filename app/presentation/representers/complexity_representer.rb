require 'roar/decorator'
require 'roar/json'
require_relative 'method_complexity_representer'

module CodePraise
  module Representer
    # Represents folder summary about repo's folder
    class Complexity < Roar::Decorator
      include Roar::JSON

      property :average
      collection :methods_complexity, extend: Representer::MethodComplexityRepresenter, class: OpenStruct
    end
  end
end
