class FollowUserController < ApplicationController
  before_action :logged_in_user
  before_action :init_user, only: [:show]

  def show
    type = params[:type].to_s.downcase
    case type
    when Settings.follow_user.follower
      @title = t "title_follower_page"
      @users = @user.followers.paginate page: params[:page]
    when Settings.follow_user.following
      @title = t "title_following_page"
      @users = @user.following.paginate page: params[:page]
    else
      redirect_to root_url
    end
    render "users/show_follow"
  end

  private

  def init_user
    @user = User.find_by id: params[:id]
    unless @user
      flash[:danger] = t "message_user_not_exist"
      redirect_to root_url
    end
  end
end
