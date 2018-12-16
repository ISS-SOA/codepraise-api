# frozen_string_literal: true

require_relative 'project_representer'

# Represents essential Repo information for API output
module CodePraise
  module Representer
    # Representer object for project clone requests
    class CloneRequest < Roar::Decorator
      include Roar::JSON

      property :project, extend: Project, class: OpenStruct
      property :id
    end
  end
end
