class PasswordResetsController < ApplicationController
  before_action :get_user, :valid_user, :check_expiration, only: %i(edit update)

  def new; end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t "layouts.application.email_check"
      redirect_to root_url
    else
      flash.now[:danger] = t "layouts.application.invalid_user"
      render :new
    end
  end

  def edit; end

  def update
    if params[:user][:password].blank?
      @user.errors.add(:password, t("layouts.application.not_empty"))
      render :edit
    elsif @user.update user_params
      log_in @user
      flash[:success] = t "layouts.application.password_reset"
      redirect_to @user
    else
      flash[:danger] = t "layouts.application.password_reset_not"
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def get_user
    @user = User.find_by email: params[:email].downcase
    return if @user

    flash[:danger] = t "layouts.application.invalid_user"
  end

  def valid_user
    return if @user&.activated? && @user&.authenticated?(:reset, params[:id])

    flash[:danger] = t "layouts.application.invalid_user"
    redirect_to root_url
  end

  def check_expiration
    return unless @user.password_reset_expired?

    flash[:danger] = t "layouts.application.expired"
    redirect_to new_password_reset_url
  end
end
