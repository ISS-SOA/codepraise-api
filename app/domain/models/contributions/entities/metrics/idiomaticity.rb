# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

module CodePraise
  module Entity
    class Idiomaticity < Dry::Struct
      include Dry::Types.module

      attribute :error_count,  Strict::Integer.optional
      attribute :error_messages, Strict::Array.of(Strict::String).optional
    end
  end
end
