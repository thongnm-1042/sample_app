class MicropostsController < ApplicationController
  before_action :logged_in_user, only: %i(create destroy)
  before_action :correct_user, only: :destroy
  before_action :new_micropost, only: :create

  def create
    @micropost.image.attach micropost_params[:image]
    if @micropost.save
      flash[:success] = t "layouts.application.created"
      redirect_to root_url
    else
      @feed_items = current_user.feed.page(params[:page])
                        .per Settings.user.per_page
      flash.now[:danger] = t "layouts.application.created_failed"
      render "static_pages/home"

    end
  end

  def destroy
    if @micropost.destroy
      flash[:success] = t "microposts.deleted_success"
      redirect_to request.referer || root_url
    else
      flash.now[:danger] = t "microposts.deleted_error"
      redirect_to root_url
    end
  end

  private

  def micropost_params
    params.require(:micropost).permit Micropost::MICROPOST_PARAMS
  end

  def correct_user
    @micropost = current_user.microposts.find_by id: params[:id]
    return if @micropost

    flash[:danger] = t "microposts.deleted_error"
    redirect_to root_url
  end

  def new_micropost
    @micropost = current_user.microposts.build micropost_params
  end
end
