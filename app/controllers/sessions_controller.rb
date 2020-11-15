class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user&.authenticate params[:session][:password]
      activate user
    else
      flash.now[:danger] = t "layouts.application.inform_failed"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private

  def activate user
    if user.activated?
      log_in user
      check_remember user
      flash[:success] = t "layouts.application.activate_success"
      redirect_back_or user
    else
      flash[:warning] = t "layouts.application.activate_fail"
      redirect_to root_url
    end
  end
end
