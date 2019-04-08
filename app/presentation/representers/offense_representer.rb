# fronze_string_literal: true

require 'roar/decorator'
require 'roar/json'

module CodePraise
  module Representer
    # Represent idiomaticity offense information
    class Offense < Roar::Decorator
      include Roar::JSON

      property :type
      property :message
      property :location
    end
  end
end