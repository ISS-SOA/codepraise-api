# frozen_string_literal: true

require 'dry/transaction'

module CodePraise
  module Service
    # Transaction to store project from Github API to database
    class AddProject
      include Dry::Transaction

      step :find_project
      step :store_project

      private

      DB_ERR_MSG = 'Having trouble accessing the database'
      GH_NOT_FOUND_MSG = 'Could not find that project on Github'

      # Expects input[:owner_name] and input[:project_name]
      def find_project(input)
        if (project = project_in_database(input))
          input[:local_project] = project
        else
          input[:remote_project] = project_from_github(input)
        end
        Success(input)
      rescue StandardError => error
        Failure(Value::Result.new(status: :not_found,
                                  message: error.to_s))
      end

      def store_project(input)
        if (new_proj = input[:remote_project])
          Repository::For.entity(new_proj).create(new_proj)
        else
          input[:local_project]
        end.yield_self do |project|
          Success(Value::Result.new(status: :created, message: project))
        end
      rescue StandardError => error
        puts error.backtrace.join("\n")
        Failure(Value::Result.new(status: :internal_error, message: DB_ERR_MSG))
      end

      # following are support methods that other services could use

      def project_from_github(input)
        Github::ProjectMapper
          .new(Api.config.GITHUB_TOKEN)
          .find(input[:owner_name], input[:project_name])
      rescue StandardError
        raise GH_NOT_FOUND_MSG
      end

      def project_in_database(input)
        Repository::For.klass(Entity::Project)
          .find_full_name(input[:owner_name], input[:project_name])
      end
    end
  end
end
