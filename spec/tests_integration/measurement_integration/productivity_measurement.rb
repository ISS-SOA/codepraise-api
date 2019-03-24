require_relative '../../helpers/spec_helper.rb'

describe "Test Productivtiy Measurement" do

  before do
    project = create(:project)
    git_repo = CodePraise::GitRepo.new(project, CodePraise::Api.config)
    folder = CodePraise::Mapper::Contributions.new(git_repo).for_folder('app')
    @file = folder.files[0]
    binding.pry
  end

  describe "Entity::MethodContribution" do
    it "should return number of method" do
      methods = @file.methods
      _(methods.count).wont_be_nil
      _(methods[0].lines).wont_be_nil
    end
  end
end