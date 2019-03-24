require 'roar/decorator'
require 'roar/json'

module CodePraise
  module Representer
    # Represents folder summary about repo's folder
    class Idiomaticity < Roar::Decorator
      include Roar::JSON

      property :error_count
      collection :error_messages
    end
  end
end
