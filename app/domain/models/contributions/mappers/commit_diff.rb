# frozen_string_literal: true

module CodePraise
  module Mapper
    # Parses git blame porcelain: https://git-scm.com/docs/git-blame/1.6.0
    module CommitDiff

      def self.parser(diff)
        diff_files = diff.stats[:files]
        diff_files.keys.map do |key|
          {
            path: key,
            name: file_name(key),
            addition: diff_files[key][:insertions],
            deletion: diff_files[key][:deletions]
          }
        end
      end

      private

      def self.file_name(file_path)
        file_path.split("/").last
      end

    end
  end
end
