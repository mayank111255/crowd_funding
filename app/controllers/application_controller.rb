class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user, :admin?

private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def admin?
    current_user && current_user.role.eql?('admin')
  end

  def authorize_user
    redirect_to :root, notice: t(:request_login) unless current_user
  end

end
