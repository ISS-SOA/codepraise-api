# frozen_string_literal: true

require_relative 'projects_representer'
require_relative 'project_folder_contributions_representer'
require_relative 'project_representer'
require_relative 'http_response_representer'

module CodePraise
  module Representer
    class For
      REP_KLASS = {
        Value::ProjectsList => ProjectsList,
        Value::ProjectFolderContributions => ProjectFolderContributions,
        Entity::Project => Project,
        String => HttpResponse
      }.freeze

      attr_reader :status_rep, :body_rep

      def initialize(result)
        if result.failure?
          @status_rep = Representer::HttpResponse.new(result.failure)
          @body_rep = @status_rep
        else
          value = result.value!
          @status_rep = Representer::HttpResponse.new(value)
          @body_rep = REP_KLASS[value.message.class].new(value.message)
        end
      end

      def http_status_code
        @status_rep.http_status_code
      end

      def to_json
        @body_rep.to_json
      end

      def status_and_body(response)
        response.status = http_status_code
        to_json
      rescue
        binding.pry
      end
    end
  end
end
