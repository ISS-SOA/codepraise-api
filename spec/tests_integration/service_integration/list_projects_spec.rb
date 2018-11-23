# frozen_string_literal: true

require_relative '../../helpers/spec_helper.rb'
require_relative '../../helpers/vcr_helper.rb'
require_relative '../../helpers/database_helper.rb'

require 'ostruct'

describe 'AppraiseProject Service Integration Test' do
  VcrHelper.setup_vcr
  DatabaseHelper.setup_database_cleaner

  before do
    VcrHelper.configure_vcr_for_github(recording: :none)
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'List Projects' do
    before do
      DatabaseHelper.wipe_database
    end

    it 'HAPPY: should return projects that are being watched' do
      # GIVEN: a valid project exists locally and is being watched
      gh_project = CodePraise::Github::ProjectMapper
        .new(GITHUB_TOKEN)
        .find(USERNAME, PROJECT_NAME)
      db_project = CodePraise::Repository::For.entity(gh_project)
        .create(gh_project)

      # WHEN: we request a list of all watched projects
      list_request = CodePraise::Value::ListRequest.to_request(
        [USERNAME + '/' + PROJECT_NAME]
      )
      result = CodePraise::Service::ListProjects.new.call(
        list_request: list_request
      )

      # THEN: we should see our project in the resulting list
      _(result.success?).must_equal true
      list = result.value!.message
      _(list.projects).must_include db_project
    end

    it 'HAPPY: should not return projects that are not being watched' do
      # GIVEN: a valid project exists locally but is not being watched
      gh_project = CodePraise::Github::ProjectMapper
        .new(GITHUB_TOKEN)
        .find(USERNAME, PROJECT_NAME)
      CodePraise::Repository::For.entity(gh_project)
        .create(gh_project)

      # WHEN: we request an empty list
      list_request = CodePraise::Value::ListRequest.to_request([])
      result = CodePraise::Service::ListProjects.new.call(
        list_request: list_request
      )

      # THEN: it should return an empty list
      _(result.success?).must_equal true
      list = result.value!.message
      _(list.projects).must_equal []
    end

    it 'SAD: should not watched projects if they are not loaded' do
      # GIVEN: we are watching a project that does not exist locally
      list_request = CodePraise::Value::ListRequest.to_request(
        [USERNAME + '/' + PROJECT_NAME]
      )

      # WHEN: we request a list of all watched projects
      result = CodePraise::Service::ListProjects.new.call(
        list_request: list_request
      )

      # THEN: it should return an empty list
      _(result.success?).must_equal true
      list = result.value!.message
      _(list.projects).must_equal []
    end
  end
end
