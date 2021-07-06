# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'


module CodePraise
  module Entity
    # Entity for a single line of code contributed by a team-member
    class FileChange < Dry::Struct

      include Dry::Types.module

      attribute :path,     Strict::String
      attribute :name,     Strict::String
      attribute :addition,      Strict::Integer
      attribute :deletion,      Strict::Integer

    end
  end
end
