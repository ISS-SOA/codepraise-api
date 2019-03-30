require 'git'


module GitCommit
  class CommitReporter

    EMPTY_SHA = '4b825dc642cb6eb9a060e54bf8d69288fbee4904'

    def initialize(gitrepo)
      @local = gitrepo.local
      @git = Git.open(@local.git_repo_path)
    end

    def commit(sha)
      @git.log(sha)
    end

    def commits(since=nil)
      commits = get_all_commits
      commits = commits.since(since) unless since.nil?
      commits
    end

    def empty_commit
      @git.gcommit(EMPTY_SHA)
    end

    private

    def get_all_commits
      n = 500
      until @git.log(n).size < n do
        n += 500
      end
      @git.log(n)
    end

  end
end