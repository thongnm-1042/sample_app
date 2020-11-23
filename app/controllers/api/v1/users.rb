module API
  module V1
    class Users < Grape::API
      include API::V1::Defaults

      before do
        authenticate_user!
      end

      prefix "api"
      version "v1", using: :path
      format :json

      resource :users do
        desc "Return all users"
        get "", root: :users do
          users = User.all
          present users, with: API::Entities::User
        end

        desc "Return a user"
        params do
          requires :id, type: String, desc: "ID of the user"
        end
        get ":id", root: "user" do
          user = User.find params[:id]
          present user, with: API::Entities::User
        end

        desc "Update a user"
        params do
          requires :id, type: String, desc: "ID of the user"
          optional :name, type: String, desc: "name of the user"
          optional :email, type: String, desc: "email of the user"
        end
        patch ":id" do
          user = User.find params[:id]
          user_params = {
            name: params[:name].presence || user.name,
            email: params[:email].presence || user.email
          }
          user.update user_params
          present user, with: API::Entities::User
        end

        desc "Delete a user"
        params do
          requires :id, type: String, desc: "ID of the user"
        end
        delete ":id" do
          user = User.find params[:id]
          user.destroy if user
          present user, with: API::Entities::User
        end
      end
    end
  end
end
