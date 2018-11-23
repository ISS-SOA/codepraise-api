# frozen_string_literal: true

require 'dry/transaction'

module CodePraise
  module Service
    # Retrieves array of all listed project entities
    class ListProjects
      include Dry::Transaction

      step :validate_list
      step :retrieve_projects

      private

      # Expects list of movies in input[:list_request]
      def validate_list(input)
        list_request = input[:list_request].call
        if list_request.success?
          Success(input.merge(list: list_request.value!))
        else
          Failure(list_request.failure)
        end
      end

      def retrieve_projects(input)
        Repository::For.klass(Entity::Project).find_full_names(input[:list])
          .yield_self { |projects| Value::ProjectsList.new(projects) }
          .yield_self do |list|
            Success(Value::Result.new(status: :ok, message: list))
          end
      rescue StandardError
        Failure(Value::Result.new(status: :internal_error,
                                  message: 'Cannot access database'))
      end
    end
  end
end
