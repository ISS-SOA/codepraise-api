# frozen_string_literal: true

require 'concurrent'

module CodePraise
  module Git
    # Git contributions report parsing and reporting services
    class BlameReporter
      NOT_FOUND_ERROR_MSG = 'Folder not found'

      def initialize(gitrepo)
        @local = gitrepo.local
      end

      def folder_report(folder_name)
        folder_name = '' if folder_name == '/'
        raise not_found_error(folder_name) unless folder_exists?(folder_name)

        @local
          .files
          .select { |file| file.start_with? folder_name }
          .yield_self do |fnames|
            @local.in_repo { analyze_files_concurrently(fnames) }
          end
      end

      def files(folder_name)
        @local.files.select { |file| file.start_with? folder_name }
      end

      def subfolders(folder_name)
        @local.folder_structure[folder_name]
      end

      def folder_structure
        @local.folder_structure
      end

      def file_report(filename)
        Git::RepoFile.new(filename).blame
      end

      private

      def folder_exists?(folder_name)
        return true if folder_name.empty?

        @local.in_repo { Dir.exist? folder_name }
      end

      def not_found_error(folder_name)
        "#{NOT_FOUND_ERROR_MSG} (#{folder_name})"
      end

      # synchronous reporting of a list of files
      def analyze_files(filenames)
        filenames.map { |fname| [fname, file_report(fname)] }
      end

      # asynchronous reporting of a list of files
      def analyze_files_concurrently(filenames)
        filenames.map do |fname|
          Concurrent::Promise
            .execute { file_report(fname) }
            .then { |freport| [fname, freport] }
        end.map(&:value)
      end
    end
  end
end
