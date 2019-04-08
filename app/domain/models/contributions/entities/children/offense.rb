# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

module CodePraise
  module Entity
    class Offense < Dry::Struct
      include Dry::Types.module

      attribute :type, Strict::String
      attribute :message, Strict::String
      attribute :location, Strict::Integer
    end
  end
end
