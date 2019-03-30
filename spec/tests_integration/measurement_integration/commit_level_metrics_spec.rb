require_relative '../../helpers/spec_helper.rb'

describe "Test Commit-Level Measurement" do

  before do
    project = create(:project)
    git_repo = CodePraise::GitRepo.new(project, CodePraise::Api.config)
    contributions = CodePraise::Mapper::Contributions.new(git_repo)
    @commits = contributions.commits
  end

  describe "Entity::Commit" do
    it "should return commit information" do
      commit = @commits[0]
      _(@commits.size).must_be :>, 0
      _(commit.total_additions).must_be :>, 0
      _(commit.total_deletions).must_be :>, 0
      _(commit.total_files).must_be :>, 0
    end
  end

  describe "Entity::FileChange" do
    it "should return addition, deletion and file information" do
      file_change = @commits[0].file_changes[0]
      _(file_change.addition).wont_be_nil
      _(file_change.deletion).wont_be_nil
      _(file_change.path).wont_be_nil
      _(file_change.name).wont_be_nil
    end
  end

end