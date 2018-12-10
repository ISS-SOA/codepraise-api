# frozen_string_literal: true

require 'dry/transaction'

module CodePraise
  module Service
    # Analyzes contributions to a project
    class AppraiseProject
      include Dry::Transaction

      step :find_project_details
      step :check_project_eligibility
      step :request_cloning_worker
      step :appraise_contributions

      private

      NO_PROJ_ERR = 'Project not found'
      DB_ERR = 'Having trouble accessing the database'
      SIZE_ERR = 'Project too large to analyze'
      CLONE_ERR = 'Could not clone this project'
      NO_FOLDER_ERR = 'Could not find that folder'
      PROCESSING_MSG = 'Processing the summary request'

      def find_project_details(input)
        input[:project] = Repository::For.klass(Entity::Project).find_full_name(
          input[:requested].owner_name, input[:requested].project_name
        )

        if input[:project]
          Success(input)
        else
          Failure(Value::Result.new(status: :not_found, message: NO_PROJ_ERR))
        end
      rescue StandardError
        Failure(Value::Result.new(status: :internal_error, message: DB_ERR))
      end

      def check_project_eligibility(input)
        input[:gitrepo] = GitRepo.new(input[:project])
        if input[:gitrepo].too_large?
          Failure(Value::Result.new(status: :bad_request, message: SIZE_ERR))
        else
          Success(input)
        end
      end

      def request_cloning_worker(input)
        return Success(input) if input[:gitrepo].exists_locally?

        Messaging::Queue.new(Api.config.CLONE_QUEUE_URL, Api.config)
          .send(Representer::Project.new(input[:project]).to_json)

        Failure(Value::Result.new(status: :processing, message: PROCESSING_MSG))
      rescue StandardError => error
        puts [error.inspect, error.backtrace].flatten.join("\n")
        Failure(Value::Result.new(status: :internal_error, message: CLONE_ERR))
      end

      def appraise_contributions(input)
        input[:folder] = Mapper::Contributions
          .new(input[:gitrepo]).for_folder(input[:requested].folder_name)

        Value::ProjectFolderContributions.new(input[:project], input[:folder])
          .yield_self do |appraisal|
            Success(Value::Result.new(status: :ok, message: appraisal))
          end
      rescue StandardError
        Failure(Value::Result.new(status: :not_found, message: NO_FOLDER_ERR))
      end
    end
  end
end
