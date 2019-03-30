# frozen_string_literal: true

module CodePraise
  module Mapper
    # Git contributions parsing and reporting services
    class Contributions
      def initialize(gitrepo)
        @gitrepo = gitrepo
      end

      def for_folder(folder_name)
        blame = Git::BlameReporter.new(@gitrepo).folder_report(folder_name)

        Mapper::FolderContributions.new(
          folder_name,
          parse_file_reports(blame),
          @gitrepo.local.git_repo_path
        ).build_entity
      end

      def commits(since=nil)
        commit_report = GitCommit::CommitReporter.new(@gitrepo)
        commits = commit_report.commits(since)
        empty_commit = commit_report.empty_commit

        commits.map do |commit|
          Mapper::Commit.new(commit, empty_commit).build_entity
        end
      end

      def parse_file_reports(blame_output)
        blame_output.map do |file_blame|
          name  = file_blame[0]
          blame = BlamePorcelain.parse_file_blame(file_blame[1])
          [name, blame]
        end.to_h
      end
    end
  end
end
