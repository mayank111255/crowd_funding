class UsersController < ApplicationController
  before_action :authorize_user, only: [:show, :edit, :index]
  before_action :verify_activation_token, only: [:account_activation]
  before_action :admin_authorization, :set_pagination_defaults, :validate_page_request, only: [:index]
  before_action :find_user_from_id, only: [:update_state, :show]
  before_action :user_authorization_for_edit, only: [:edit, :update]

  def index
    @users = User.load_users(USERS_PER_PAGE, params[:page])
  end

  def create
    @user = User.new(signup_params)
    respond_to do |format|
      if @user.generate_account_activation_token
        flash[:notice] = t(:account_created)
        format.json { render json: { redirect_url: root_url } }
      else
        format.json { render json: { errors: @user.errors.messages.to_h } }
      end
    end
  end

  def show
    render
  end

  def edit
    current_user.build_associated_objects
  end

  def account_activation
    flash[:notice] = @user.activate_account ? t(:account_activated)  : t(:request_failure)
    redirect_to :root
  end

  def update_state
    respond_to do |format|
      @user.toggle!(:is_activated)
      format.json { render json: { state: @user.is_activated? } }
    end
  end

  def update
    current_user.update_account(update_params) ? after_update : (render 'edit')
  end

  def contribution
    @contributions = current_user.contributions
  end

  def update_image
    current_user.update_account(image_params)
    @user = current_user
    render 'show'
  end

  private

  def after_update
    session[:amount] ? (redirect_to build_transaction_for_project_url(session[:project_id])) : (redirect_to :user, notice: 'Account has been updated successfully')
  end

  def verify_activation_token
    unless @user = User.find_by(account_activation_token: params[:token])
      redirect_to :root, notice: t(:invalid_request)
    end
  end

  def admin_authorization
    (redirect_to :root) unless admin?
  end

  def find_user_from_id
    redirect_to :root, notice: not_found unless @user = User.find_by(id: params[:id])
  end

  def not_found
    t(:not_found, object: 'user')
  end

  def validate_page_request
    if params[:page] > @total_pages || params[:page] < 1
      flash.now[:notice] = not_found
      render
    end
  end

  def set_pagination_defaults
    params[:page] = params[:page] ? params[:page].to_i : 1
    @total_pages = (User.count_all_users.to_f / USERS_PER_PAGE).ceil
  end

  def user_authorization_for_edit
    redirect_to :root unless current_user.id == params[:id].to_i
  end
  
  def signup_params
    params.permit(:name, :email, :password, :password_confirmation)
  end

  def update_params
    params.require(:user).permit(:name, profile_attributes: [:id, :phone_no, :current_address, :permanent_address, :permanent_account_number],
                                 documents_attributes: [:attachable_subtype, :attachment, :id] )
  end

  def image_params
    params.require(:user).permit(:image)
  end
  
end
