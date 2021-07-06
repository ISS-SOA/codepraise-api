# frozen_string_literal: true

module CodePraise
  module Representer
    class FileChange < Roar::Decorator
      include Roar::JSON

      property :path
      property :name
      property :addition
      property :deletion
    end
  end
end
