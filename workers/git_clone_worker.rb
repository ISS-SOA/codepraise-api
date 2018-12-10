# frozen_string_literal: true

require_relative '../init.rb'

require 'econfig'
require 'shoryuken'

# Shoryuken worker class to clone repos in parallel
class GitCloneWorker
  extend Econfig::Shortcut
  Econfig.env = ENV['RACK_ENV'] || 'development'
  Econfig.root = File.expand_path('..', File.dirname(__FILE__))

  Shoryuken.sqs_client = Aws::SQS::Client.new(
    access_key_id: config.AWS_ACCESS_KEY_ID,
    secret_access_key: config.AWS_SECRET_ACCESS_KEY,
    region: config.AWS_REGION
  )

  include Shoryuken::Worker
  shoryuken_options queue: config.CLONE_QUEUE_URL, auto_delete: true

  def perform(_sqs_msg, request)
    project = CodePraise::Representer::Project
      .new(OpenStruct.new).from_json(request)
    gitrepo = CodePraise::GitRepo.new(project).clone!
  rescue CodePraise::GitRepo::Errors::CannotOverwriteLocalGitRepo
    # only catch errors you absolutely expect!
    puts 'CLONE EXISTS -- ignoring request'
  end
end
