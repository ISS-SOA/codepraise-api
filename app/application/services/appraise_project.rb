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

      # input hash keys required: :project, :requested, :config
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
        input[:gitrepo] = GitRepo.new(input[:project], input[:config])
        if input[:gitrepo].too_large?
          Failure(Value::Result.new(status: :bad_request, message: SIZE_ERR))
        else
          Success(input)
        end
      end

      def request_cloning_worker(input)
        return Success(input) if input[:gitrepo].exists_locally?

        notify_workers(input)
        Failure(
          Value::Result.new(status: :processing,
                            message: { request_id: input[:request_id] })
        )
      rescue StandardError => error
        puts [error.inspect, error.backtrace].flatten.join("\n")
        Failure(Value::Result.new(status: :internal_error, message: CLONE_ERR))
      end

      def appraise_contributions(input)
        contributions = Mapper::Contributions.new(input[:gitrepo])
        input[:folder] = contributions.for_folder(input[:requested].folder_name)
        input[:commits] = contributions.commits

        Value::ProjectFolderContributions.new(input[:project], input[:folder], input[:commits])
          .yield_self do |appraisal|
            Success(Value::Result.new(status: :ok, message: appraisal))
          end
      rescue StandardError
        Failure(Value::Result.new(status: :not_found, message: NO_FOLDER_ERR))
      end

      # Utility functions

      def clone_request_json(input)
        Value::CloneRequest.new(input[:project], input[:request_id])
          .yield_self { |request| Representer::CloneRequest.new(request) }
          .yield_self(&:to_json)
      end

      def notify_workers(input)
        queues = [Api.config.CLONE_QUEUE_URL, Api.config.REPORT_QUEUE_URL]

        queues.each do |queue_url|
          Concurrent::Promise.execute do
            Messaging::Queue.new(queue_url, Api.config)
              .send(clone_request_json(input))
          end
        end
      end
    end
  end
end
