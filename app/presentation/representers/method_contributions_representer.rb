# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

require_relative 'contributor_representer'
require_relative 'credit_share_representer'

module CodePraise
  module Representer
    # Represents folder summary about repo's folder
    class MethodContributions < Roar::Decorator
      include Roar::JSON

      property :name
      property :share
    end
  end
end
