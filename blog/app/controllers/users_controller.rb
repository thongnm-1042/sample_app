class UsersController < ApplicationController
  before_action :logged_in_user, only: %i(index edit update destroy)
  before_action :load_user, except: %i(index new create)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  def index
    @users = User.page(params[:page]).per Settings.user.per_page
  end

  def show
    @microposts = @user.microposts.page(params[:page])
                            .per Settings.user.per_page
  end

  def new
    @user = User.new
  end

  def edit; end

  def create
    @user = User.new user_params
    if @user.save
      UserMailer.account_activation(@user).deliver_now
      flash[:info] = t "layouts.application.email_check"
      redirect_to @user
    else
      flash[:danger] = t "layouts.application.inform_failed"
      render :new
    end
  end

  def update
    if @user.update user_params
      flash[:success] = t "users.new.update_success"
      redirect_to @user
    else
      flash[:danger] = t "users.new.update_fail"
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "users.new.delete"
      redirect_to users_url
    else
      flash[:danger] = t "users.new.delete_fail"
      redirect_to root_path
    end
  end

  private

  def user_params
    params.require(:user).permit User::PERMIT_ATTRIBUTES
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t "users.new.cautious_login"
    redirect_to login_url
  end

  def correct_user
    return if current_user? @user

    flash[:warning] = t "users.new.not_correct"
    redirect_to root_url
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t "users.new.not_found"
    redirect_to root_path
  end
end
