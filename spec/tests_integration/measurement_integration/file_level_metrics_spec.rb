# frozen_string_literal: true

require_relative '../../helpers/spec_helper.rb'

describe 'Test File-Level Measurement' do
  before do
    project = create(:project)
    git_repo = CodePraise::GitRepo.new(project, CodePraise::Api.config)
    contributions = CodePraise::Mapper::Contributions.new(git_repo)
    @folder = contributions.for_folder('')
    @file = @folder.files[35]
  end

  describe CodePraise::Entity::Complexity do
    it 'should return complexity score' do
      _(@file.complexity.average).wont_be_nil
      _(@file.complexity.methods.keys).wont_be_empty
    end
  end

  describe CodePraise::Entity::MethodContribution do
    it 'should count number of method correctly' do
      _(@file.methods.count).must_equal 2
      _(@file.methods.map { |method| method.lines.count }).must_equal [3, 3]
    end
  end

  describe CodePraise::Mixins::CommentCalculator do
    it 'should count the multiline comment' do
      _(@file.multiline_comment_count).must_equal 1
    end

    it 'should count the signle line comment' do
      _(@file.singleline_comment_count).must_equal 1
    end
  end
end
