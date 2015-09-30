class SessionsController < ApplicationController
  before_action :load_user_from_email, :authenticate_user, only: [:create]

  def create
    session[:user_id] = @user.id
    flash[:notice] = t(:login_success)
    head 200
  end

  def destroy
    reset_session
    redirect_to :root, notice: t(:logout_success)
  end

private

  def authenticate_user
    head 401 unless @user.authenticate(params[:password])
  end

  def load_user_from_email
    head 401 unless (@user = User.find_by(email: params[:email]))
  end
  
end
