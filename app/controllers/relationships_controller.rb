class RelationshipsController < ApplicationController
  before_action :logged_in_user

  def create
    @user = User.find_by id: params[:followed_id]
    if @user
      current_user.follow @user
      @relation_ship = current_user.active_relationships.find_by followed_id: @user.id
      convert_ajax @user
    else
      flash[:danger] = t "message_user_not_exist"
      redirect_to root_url
    end
  end

  def destroy
    @relation = Relationship.find_by id: params[:id]
    if @relation
      @user =  @relation.followed
      current_user.unfollow @user
      convert_ajax @user
    else
      flash[:danger] = t "message_user_not_exist"
      redirect_to root_url
    end
  end

  private

  def convert_ajax user
    respond_to do |format|
      format.html {redirect_to user}
      format.js
    end
  end
end
