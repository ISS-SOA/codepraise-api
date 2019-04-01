# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

require_relative 'contributor_representer'
require_relative 'credit_share_representer'
require_relative 'file_path_representer'
require_relative 'line_contribution_representer'
require_relative 'complexity_representer'
require_relative 'idiomaticity_representer'
require_relative 'method_contributions_representer'

module CodePraise
  module Representer
    # Represents folder summary about repo's folder
    class FileContributions < Roar::Decorator
      include Roar::JSON

      property :line_count
      property :total_credits
      property :total_methods
      property :multiline_comments
      property :comments
      collection :methods, extend: Representer::MethodContributions, class: OpenStruct
      property :file_path, extend: Representer::FilePath, class: OpenStruct
      property :credit_share, extend: Representer::CreditShare, class: OpenStruct
      property :complexity, extend: Representer::Complexity, class: OpenStruct
      property :idiomaticity, extend: Representer::Idiomaticity, class: OpenStruct
      collection :contributors, extend: Representer::Contributor, class: OpenStruct
    end
  end
end
