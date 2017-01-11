class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user, only: :destroy
  before_action :init_micropost, only: [:edit, :update]
  after_action  :get_page, only: [:edit]

  def create
    @micropost = current_user.microposts.build micropost_params
    if @micropost.save
      flash[:success] = t "message_micro_post_create_success"
      redirect_to root_url
    else
      @feed_items = []
      render "static_pages/home"
    end
  end

  def destroy
    @micropost.destroy ? flash[:success] =  t("message_micro_post_delete_success") :
    flash[:danger] =  t("message_micro_post_delete_fail")
    redirect_to request.referrer || root_url
  end

  def edit
    @micropost
    @feed_items = current_user.feed.paginate page: params[:page]
    respond_to do |format|
      format.html {render "static_pages/home"}
      format.js
    end
  end

  def update
    @micropost.update_attributes(micropost_params)
    if @micropost.save
      flash[:success] = t "message_edit_micropost_success"
      @micropost = nil
      redirect_to root_url + "?page=" + $page
    end

  end

  private

  def micropost_params
    params.require(:micropost).permit :content, :picture
  end

  def correct_user
    @micropost = current_user.microposts.find_by id: params[:id]
    unless @micropost.present?
      redirect_to root_url
    end
  end

  def init_micropost
    @micropost = current_user.microposts.find_by id: params[:id]
    unless @micropost
      redirect_to current_user
    end
  end

  def get_page
    $page= params[:page]
  end
end
