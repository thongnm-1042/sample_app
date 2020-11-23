module API
  module V1
    class Auth < Grape::API
      include API::V1::Defaults

      helpers do
        def represent_user_with_token user
          present jwt_token: Authentication.encode({user_id: user.id})
        end
      end

      resources :auth do
        desc "Sign in"
        params do
          requires :email
          requires :password
        end
        post "/sign_in" do
          user = User.find_by email: params[:email]
          if user&.authenticate params[:password]
            represent_user_with_token user
          else
            error!("Invalid email/password combination", 401)
          end
        end

        desc "Sign up"
        params do
          requires :email
          requires :password
          requires :confirm_password
          requires :name
        end
        post "/sign_up" do
          if params[:password] != params[:confirm_password]
            error!("password not match with confirm password !", 401)
          end
          user_params = {
            email: params[:email],
            password: params[:password],
            name: params[:name]
          }
          user = User.new user_params
          user.save
          present user, with: API::Entities::User
        end
      end
    end
  end
end
