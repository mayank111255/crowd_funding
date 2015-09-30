class PasswordsController < ApplicationController
  before_action :find_user, :generate_token, only: [:create]
  before_action :user_authorization_by_token, only: [:edit]
  before_action :process_updation, only: [:update]

  def new
    redirect_to :root if current_user
  end

  def create
  end

  def edit
    current_user ? (render 'change') : (render 'reset')
  end

  def update
    is_updation_successful = current_user ? current_user.update_password(user_params, true) : @user.update_password(user_params)
    is_updation_successful ? (redirect_to :root, notice: t(:password_changed)) : (render 'reset')
  end

private

  def generate_token
    if @user.generate_reset_password_token
      redirect_to :root, notice: t(:reset_password)
    else
      flash.now[:notice] = t(:request_failure)
      render 'new'
    end
  end

  def user_authorization_by_token
    if current_user
      redirect_to :root if params[:token]
    else
      (redirect_to :root, notice: t(:invalid_request)) unless token_valid?
    end
  end
  
  def process_updation
    current_user ? authenticate_user : user_authorization_by_token
  end

  def token_valid?
    @user = User.find_by(reset_password_token: params[:token]) if params[:token]
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

  def find_user
    unless @user = User.find_by(email: params[:user][:email])
      flash.now[:notice] = 'Invalid Email'
      render 'new'
    end
  end

  def authenticate_user
    unless current_user.authenticate(params[:user][:current_password])
      flash.now[:notice] = t(:current_password_error)
      render 'change'
    end
  end

end
