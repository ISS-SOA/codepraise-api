require_relative '../../helpers/spec_helper.rb'

describe "Test File-Level Measurement" do

  before do
    project = create(:project)
    git_repo = CodePraise::GitRepo.new(project, CodePraise::Api.config)
    contributions = CodePraise::Mapper::Contributions.new(git_repo)
    @folder = contributions.for_folder('app')
    @file = @folder.files[0]
    binding.pry
  end

  describe "Entity::Complexity" do
    it "should return complexity score" do
      _(@file.complexity.average).wont_be_nil
      _(@file.complexity.methods_complexity.keys).wont_be_empty
    end
  end

  describe "Entity::Idiomaticity" do
    it "should count number of unidiomatic code" do
      _(@file.idiomaticity.error_count).wont_be_nil
      _(@file.idiomaticity.error_messages).wont_be_empty
    end
  end

  describe "Annotation" do
    it "should return number of annotation" do
      _(@file.total_annotations).wont_be_nil
    end
  end

  describe "Entity::MethodContribution" do
    it "should return number of method" do
      methods = @file.methods
      _(methods.count).wont_be_nil
      _(methods[0].lines).wont_be_nil
    end
  end

  describe "Entity::CollectiveOwnership" do
    it "should return personal code ownership" do
      _(@folder.collective_ownership.keys).wont_be_empty
    end
  end

end