# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'
require_relative 'offense'

module CodePraise
  module Entity
    class Idiomaticity < Dry::Struct
      include Dry::Types.module

      attribute :offenses, Strict::Array.of(Entity::Offense).optional
    end
  end
end
