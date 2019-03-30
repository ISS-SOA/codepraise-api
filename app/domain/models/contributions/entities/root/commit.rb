# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'
require_relative '../children/contributor'


module CodePraise
  module Entity
    # Entity for a single line of code contributed by a team-member
    class Commit < Dry::Struct

      include Dry::Types.module

      attribute :committer,      Contributor
      attribute :sha,           Strict::String
      attribute :date,          Params::DateTime
      attribute :size,          Strict::Integer
      attribute :message,       Strict::String
      attribute :file_changes,  Strict::Array.of(FileChange)

      def total_additions
        file_changes.map(&:addition).reduce(&:+)
      end

      def total_deletions
        file_changes.map(&:deletion).reduce(&:+)
      end

      def total_files
        file_changes.count
      end
    end
  end
end
