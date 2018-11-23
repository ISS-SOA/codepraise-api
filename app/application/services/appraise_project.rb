# frozen_string_literal: true

require 'dry/transaction'

module CodePraise
  module Service
    # Analyzes contributions to a project
    class AppraiseProject
      include Dry::Transaction

      step :retrieve_remote_project
      step :clone_remote
      step :appraise_contributions

      private

      NO_PROJ_MSG = 'Project not found'
      DB_ERR_MSG = 'Having trouble accessing the database'
      CLONE_ERR_MSG = 'Could not clone this project'
      FOLDER_NOT_FOUND_MSG = 'Could not find that folder'

      def retrieve_remote_project(input)
        input[:project] = Repository::For.klass(Entity::Project).find_full_name(
          input[:requested].owner_name, input[:requested].project_name
        )

        if input[:project]
          Success(input)
        else
          Failure(Value::Result.new(status: :not_found, message: NO_PROJ_MSG))
        end
      rescue StandardError
        Failure(Value::Result.new(status: :internal_error, message: DB_ERR_MSG))
      end

      def clone_remote(input)
        gitrepo = GitRepo.new(input[:project])
        gitrepo.clone! unless gitrepo.exists_locally?

        Success(input.merge(gitrepo: gitrepo))
      rescue StandardError
        puts error.backtrace.join("\n")
        Failure(Value::Result.new(status: :internal_error,
                                  message: CLONE_ERR_MSG))
      end

      def appraise_contributions(input)
        input[:folder] = Mapper::Contributions
          .new(input[:gitrepo]).for_folder(input[:requested].folder_name)

        Value::ProjectFolderContributions.new(input[:project], input[:folder])
          .yield_self do |appraisal|
            Success(Value::Result.new(status: :ok, message: appraisal))
          end
      rescue StandardError
        Failure(Value::Result.new(status: :not_found,
                                  message: FOLDER_NOT_FOUND_MSG))
      end
    end
  end
end
