require_relative '../../helpers/spec_helper.rb'

describe "Test Quality Measurement" do

  before do
    project = create(:project)
    git_repo = CodePraise::GitRepo.new(project, CodePraise::Api.config)
    folder = CodePraise::Mapper::Contributions.new(git_repo).for_folder('app')
    @file = folder.files[0]
  end

  describe "Entity::Complexity" do
    it "should return complexity score" do
      _(@file.complexity.average).wont_be_nil
      _(@file.complexity.methods_complexity.keys).wont_be_empty
    end
  end

  describe "Entity::Idiomaticity" do
    it "should count number of unidiomatic code" do
      _(@file.idiomaticity.count).wont_be_nil
      _(@file.idiomaticity.messages).wont_be_empty
      binding.pry
    end
  end
end