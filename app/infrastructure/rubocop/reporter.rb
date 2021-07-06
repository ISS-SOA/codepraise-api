# frozen_string_literal: true

require_relative 'command'

module CodePraise
  module Rubocop
    class Reporter
      def initialize(git_repo_path, target = '')
        @git_repo_path = git_repo_path
        @command = Command.new
          .target(target)
          .except('Metrics')
          .format('json')
          .with_stderr_output
      end

      def report
        @report ||= JSON.parse(call)['files'].each_with_object({}) do |file, hash|
          hash[file['path']] = file['offenses']
        end
      end

      private

      def call
        in_repo do
          `#{@command.full_command}`
        end
      end

      def in_repo(&block)
        Dir.chdir(@git_repo_path) { yield block }
      end
    end
  end
end
