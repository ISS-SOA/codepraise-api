# frozen_string_literal: true

require_relative '../../helpers/spec_helper.rb'
require_relative '../../helpers/vcr_helper.rb'
require_relative '../../helpers/database_helper.rb'

describe 'AddProject Service Integration Test' do
  VcrHelper.setup_vcr
  DatabaseHelper.setup_database_cleaner

  before do
    VcrHelper.configure_vcr_for_github(recording: :none)
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'Retrieve and store project' do
    before do
      DatabaseHelper.wipe_database
    end

    it 'HAPPY: should be able to find and save remote project to database' do
      # GIVEN: a valid url request for an existing remote project:
      project = CodePraise::Github::ProjectMapper
        .new(GITHUB_TOKEN).find(USERNAME, PROJECT_NAME)

      # WHEN: the service is called with the request form object
      project_made = CodePraise::Service::AddProject.new.call(
        owner_name: USERNAME, project_name: PROJECT_NAME)

      # THEN: the result should report success..
      _(project_made.success?).must_equal true

      # ..and provide a project entity with the right details
      rebuilt = project_made.value!.message

      _(rebuilt.origin_id).must_equal(project.origin_id)
      _(rebuilt.name).must_equal(project.name)
      _(rebuilt.size).must_equal(project.size)
      _(rebuilt.ssh_url).must_equal(project.ssh_url)
      _(rebuilt.http_url).must_equal(project.http_url)
      _(rebuilt.contributors.count).must_equal(project.contributors.count)

      project.contributors.each do |member|
        found = rebuilt.contributors.find do |potential|
          potential.origin_id == member.origin_id
        end

        _(found.username).must_equal member.username
        _(found.email).must_equal member.email
      end
    end

    it 'HAPPY: should find and return existing project in database' do
      # GIVEN: a valid url request for a project already in the database:
      db_project = CodePraise::Service::AddProject.new.call(
        owner_name: USERNAME, project_name: PROJECT_NAME).value!.message

      # WHEN: the service is called with the request form object
      project_made = CodePraise::Service::AddProject.new.call(
        owner_name: USERNAME, project_name: PROJECT_NAME)

      # THEN: the result should report success..
      _(project_made.success?).must_equal true

      # ..and find the same project that was already in the database
      rebuilt = project_made.value!.message
      _(rebuilt.id).must_equal(db_project.id)

      # ..and provide a project entity with the right details
      _(rebuilt.origin_id).must_equal(db_project.origin_id)
      _(rebuilt.name).must_equal(db_project.name)
      _(rebuilt.size).must_equal(db_project.size)
      _(rebuilt.ssh_url).must_equal(db_project.ssh_url)
      _(rebuilt.http_url).must_equal(db_project.http_url)
      _(rebuilt.contributors.count).must_equal(db_project.contributors.count)

      db_project.contributors.each do |member|
        found = rebuilt.contributors.find do |potential|
          potential.origin_id == member.origin_id
        end

        _(found.username).must_equal member.username
        _(found.email).must_equal member.email
      end
    end

    it 'SAD: should gracefully fail for non-existent project details' do
      # WHEN: the service is called with non-existent project details
      project_made = CodePraise::Service::AddProject.new.call(
        owner_name: 'wfkah4389', project_name: 'foobarsdhkfw2')

      # THEN: the service should report failure with an error message
      _(project_made.success?).must_equal false
      _(project_made.failure.message.downcase).must_include 'could not find'
    end
  end
end
