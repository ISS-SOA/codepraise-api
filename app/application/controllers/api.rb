# frozen_string_literal: true

require 'roda'
require_relative 'lib/init'

module CodePraise
  # Web App
  class Api < Roda
    include RouteHelpers

    plugin :halt
    plugin :all_verbs
    plugin :caching
    use Rack::MethodOverride

    route do |routing|
      response['Content-Type'] = 'application/json'

      # GET /
      routing.root do
        message = "CodePraise API v1 at /api/v1/ in #{Api.environment} mode"

        result_response = Representer::HttpResponse.new(
          Value::Result.new(status: :ok, message: message)
        )

        response.status = result_response.http_status_code
        result_response.to_json
      end

      routing.on 'api/v1' do
        routing.on 'projects' do
          routing.on String, String do |owner_name, project_name|
            # GET /projects/{owner_name}/{project_name}[/folder_namepath/]
            routing.get do
              Cache::Control.new(response).turn_on if Env.new(Api).production?

              request_id = [request.env, request.path, Time.now.to_f].hash

              path_request = ProjectRequestPath.new(
                owner_name, project_name, request
              )

              result = Service::AppraiseProject.new.call(
                requested: path_request,
                request_id: request_id,
                config: Api.config
              )

              Representer::For.new(result).status_and_body(response)
            end

            # POST /projects/{owner_name}/{project_name}
            routing.post do
              result = Service::AddProject.new.call(
                owner_name: owner_name, project_name: project_name
              )

              Representer::For.new(result).status_and_body(response)
            end
          end

          routing.is do
            # GET /projects?list={base64 json array of project fullnames}
            routing.get do
              result = Service::ListProjects.new.call(
                list_request: Value::ListRequest.new(routing.params)
              )

              Representer::For.new(result).status_and_body(response)
            end
          end
        end
      end
    end
  end
end
