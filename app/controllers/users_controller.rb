class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy
  before_action :init_user, except: [:new, :index]

  def index
    @users = User.paginate page: params[:page]
  end

  def show
    @user
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      log_in @user
      flash[:success] = t "message_signup_succes"
      redirect_to @user
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
    @user.destroy
    @user.destroyed ?   flash[:success] = t("message_delete_success"):
      flash[:danger] = t "message_delete_failed"
    redirect_to users_url
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end

  def logged_in_user
    unless logged_in?
      store_location
        flash[:danger] = t "message_not_login"
      redirect_to login_url
    end
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
      flash[:danger] = t "message_user_not_Exist"
      redirect_to root_url
    end
  end
end
