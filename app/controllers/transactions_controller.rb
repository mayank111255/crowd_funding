class TransactionsController < ApplicationController
  before_action :load_project, only: [:new, :build, :create]
  before_action :authorize_user, :validate_new_request, only: [:new]
  before_action :validate_build_request, only: [:build]
  before_action :charge_card, only: [:create]
  before_action :validate_token, only: [:download_receipt]
  before_action :admin_authorization, only: [:index]

  def index
  end

  def new
    head 200, location: build_transaction_for_project_url(params[:id])
  end

  def build
    render
  end

  def create
    if @project.transactions.create(transaction_params.merge(default_params))
      render 'success'
    else
      flash[:notice] = t(:request_failure)
      redirect_to build_transaction_for_project_url(session[:project_id])
    end
  end

  def download_receipt
    send_data(render_to_string('download_receipt', layout: false), disposition: 'attachment', filename: 'payment_receipt.txt')
  end

private
  
  def admin_authorization
    admin? ? load_transactions : (redirect_to :root, notice: t(:only_admin_can_see))
  end

  def load_transactions
    @transactions = Transaction.all
  end

  def validate_token
    unless @transaction = Transaction.find_by(stripeToken: params[:stripeToken])
      redirect_to :root, notice: t(:invalid_request)
    end
  end

  def charge_card
    begin
      @charge = Stripe::Charge.create(amount: session[:amount], currency: 'usd', source: params[:stripeToken])
    rescue Stripe::CardError, Stripe::InvalidRequestError => error 
      flash[:notice] = error.message
      redirect_to build_transaction_for_project_url(session[:project_id])
    end    
  end

  def authorize_user
    head 401 unless current_user
  end

  def validate_new_request
    if required_params_present?
      session[:amount] = params[:amount].to_i
      session[:project_id] = params[:id]
      check_necessary_documents_presence
    else
      head 400
    end
  end

  def load_project
    @project = Project.find_by(id: params[:id]) if params[:id]
  end

  def required_params_present?
    params[:amount] && @project && params[:amount].to_i >= @project.user_minimum_contribution
  end

  def check_necessary_documents_presence
    unless current_user.profile_complete?
      flash[:notice] = t(:request_profile_completion)
      head 402, location: edit_user_url(current_user)
    end
  end

  def validate_build_request
    redirect_to :root, notice: t(:invalid_request) unless session[:amount] && session[:project_id]
  end

  def default_params
    { status: 'completed', amount: session[:amount], user_id: current_user.id, charge_id: @charge.id }
  end

  def transaction_params
    params.permit(:stripeToken, :stripeEmail, :mode)
  end

end