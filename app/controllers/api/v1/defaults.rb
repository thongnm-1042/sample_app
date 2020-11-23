module API
  module V1
    module Defaults
      extend ActiveSupport::Concern
      included do
        prefix "api"
        version "v1", using: :path
        format :json

        rescue_from ActiveRecord::RecordNotFound do |e|
          error_response(message: e.message, status: 404)
        end

        rescue_from :all do |e|
          if Rails.env.development?
            raise e
          else
            error_response(message: e.message, status: 500)
          end
        end

        helpers do
          def authenticate_user!
            token = request.headers["Jwt-Token"]
            user_id = Authentication.decode(token)["user_id"] if token
            @current_user = User.find_by_id user_id
            unless @current_user
              api_error!("You need to log in to use the app", "failure", 401, {})
            end
          end
        end
      end
    end
  end
end
