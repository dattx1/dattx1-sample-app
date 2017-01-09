class PasswordResetsController < ApplicationController
  before_action :get_user, :valid_user, :check_expiration, only: [:edit, :update]

  def new
  end

  def edit
  end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if @user.nil?
      flash.now[:danger] = t "message_reset_password_email_not_found"
      render :new
    else
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t "message_reset_password_infor"
      redirect_to root_url
    end
  end

  def update
    if params[:user][:password].empty?
      @user.errors.add :password, t("message_password_canot_empty")
      render :edit
    elsif @user.update_attributes user_params
      log_in @user
      flash[:success] = t "message_reset_password_success"
      redirect_to @user
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def get_user
    @user = User.find_by(email: params[:email].downcase)
    unless @user.present?
      flash.now[:danger] = t "message_reset_password_email_not_found"
      render :new
    end
  end

  def valid_user
    unless (@user && @user.activated? &&
     @user.authenticated?(:reset, params[:id]))
      flash.now[:danger] = t "message_user_invalid"
      redirect_to root_url
    end
  end

  def check_expiration
    if @user.password_reset_expired?
      flash[:danger] = t "message_password_exprired"
      redirect_to new_password_reset_url
    end
  end
end
