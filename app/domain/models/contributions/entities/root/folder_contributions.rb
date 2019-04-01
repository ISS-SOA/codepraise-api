# frozen_string_literal: true


module CodePraise
  module Entity
    # Entity for folder contributions
    class FolderContributions < SimpleDelegator
      include Mixins::ContributionsCalculator
      include Mixins::CodeOnwershipCalculator

      attr_reader :path, :files, :repo_path

      def initialize(path:, files:, repo_path:)
        @path = path
        @files = files
        @repo_path = repo_path
        super(Types::HashedArrays.new)

        base_files.each { |file|   self[file.file_path.filename] = file }
        subfolders.each { |folder| self[folder.path] = folder }
      end

      def line_count
        files.map(&:line_count).reduce(&:+)
      end

      def total_credits
        files.map(&:total_credits).sum
      end

      def lines
        files.map(&:lines).reduce(&:+)
      end

      def base_files
        @base_files ||= files.select do |file|
          file.file_path.directory == comparitive_path
        end
      end

      def subfolders
        return @subfolders if @subfolders

        folders = nested_files
          .each_with_object(Types::HashedArrays.new) do |nested, lookup|
            subfolder = nested.file_path.folder_after(comparitive_path)
            lookup[subfolder] << nested
          end

        @subfolders = folders.map do |folder_name, folder_files|
          FolderContributions.new(path: folder_name, files: folder_files, repo_path: @repo_path)
        end
      end

      def any_subfolders?
        subfolders.count.positive?
      end

      def any_base_files?
        base_files.count.positive?
      end

      def credit_share
        @credit_share ||= files.map(&:credit_share).reduce(&:+)
      end

      def contributors
        credit_share.contributors
      end

      def subfolder_contributions
        result = credit_share.contributors.inject({}) {|hash, contributor| hash[contributor.username] = []; hash}
        subfolders.each do |subfolder|
          result.each do |k, v|
            percentage = subfolder.credit_share.percentage
            result[k].push({percentage: (percentage[k].nil? ? 0.0 : percentage[k]), path: subfolder.path})
          end
        end
        result
      end

      private

      def comparitive_path
        path.empty? ? path : path + '/'
      end

      def nested_files
        files - base_files
      end
    end
  end
end
