# frozen_string_literal: true

require 'fileutils'
require_relative 'remote_repo.rb'

module CodePraise
  module Git
    module Errors
      # Local repo not setup or invalid
      InvalidLocalGitRepo = Class.new(StandardError)
    end

    # Manage local Git repository
    class LocalGitRepo
      ONLY_FOLDERS = '**/'
      FILES_AND_FOLDERS = '**/*'
      TEXT_FILES = %w[rb py c js java css html slim md yml json txt].join('|')
      CODE_FILENAME_MATCH = /\.(#{TEXT_FILES})$/.freeze

      attr_reader :git_repo_path

      def initialize(remote, repostore_path)
        @remote = remote
        @git_repo_path = [repostore_path, @remote.unique_id].join('/')
      end

      def clone_remote
        @remote.local_clone(@git_repo_path) do |line|
          yield line if block_given?
        end
        self
      end

      def directory_exists?(dir_name)
        in_repo do
          Dir.exist? dir_name
        end
      end

      def folder_structure
        raise_unless_setup

        @folder_structure ||= in_repo do
          Dir.glob(ONLY_FOLDERS).reduce('/' => []) do |structure, full_path|
            parts = full_path.split('/')
            parent = parts.length.equal?(1) ? '/' : parts[0..-2].join('/')
            (structure[parent] ||= []).push(full_path)
            structure
          end
        end
      end

      def files
        raise_unless_setup
        return @files if @files

        @files = in_repo do
          Dir.glob(FILES_AND_FOLDERS).select do |path|
            File.file?(path) && (path =~ CODE_FILENAME_MATCH)
          end
        end
      end

      def in_repo(&block)
        raise_unless_setup
        Dir.chdir(@git_repo_path) { yield block }
      end

      def exists?
        Dir.exist? @git_repo_path
      end

      def delete
        FileUtils.rm_rf(@git_repo_path)
      end

      private

      def raise_unless_setup
        raise Errors::InvalidLocalGitRepo unless exists?
      end

      def wipe
        FileUtils.rm_rf @git_repo_path
      end
    end
  end
end
