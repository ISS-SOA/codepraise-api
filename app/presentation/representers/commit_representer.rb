# frozen_string_literal: true

require_relative 'contributor_representer'
require_relative 'file_change_representer'

module CodePraise
  module Representer
    class Commit < Roar::Decorator
      include Roar::JSON

      property :committer, extend: Representer::Contributor, class: OpenStruct
      property :sha
      property :message
      property :date
      property :size
      property :total_additions
      property :total_deletions
      property :total_files
      collection :file_changes, extend: Representer::FileChange, class: OpenStruct
    end
  end
end
