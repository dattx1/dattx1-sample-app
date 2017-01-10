class UsersController < ApplicationController
  before_action :logged_in_user, except: [:show, :new, :create]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy
  before_action :init_user, except: [:new, :index, :create]

  def index
    @users = User.paginate page: params[:page]
  end

  def show
    @user
    @microposts = @user.microposts.paginate(page: params[:page])
    @relation_ship = current_user.active_relationships.find_by(followed_id: @user.id) if
      current_user.following? @user
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      flash[:success] = edit_account_activation_url(@user.activation_token,  email: @user.email)
      flash[:info] = t "message_activation_email"
      redirect_to root_url
    else
      render :new
    end
  end

  def edit
    @user
  end

  def update
    if @user.update_attributes user_params
      flash[:success] = t "message_edit_success"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    @user.destroy ? flash[:success] = t("message_delete_success"):
      flash[:danger] = t("message_delete_failed")
    redirect_to users_url
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end

  def correct_user
    @user = User.find_by id: params[:id]
    unless @user == current_user
        flash[:danger] = t "message_access_denied"
      redirect_to root_url
    end
  end

  def admin_user
    unless current_user.admin?
        flash[:danger] = t "message_un_authority"
      redirect_to root_url
    end
  end

  def init_user
    @user = User.find_by id: params[:id]
    unless @user.present?
      flash[:danger] = t "message_user_not_exist"
      redirect_to root_url
    end
  end
end
