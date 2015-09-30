class UserMailer < ApplicationMailer

  def default_url_options
    { host: 'localhost:3000' }
  end

  def send_reset_password_mail(user)
    @user, @url = user, edit_passwords_url(token: user.reset_password_token)
    mail(to: user.email, subject: "verification mail to reset password") do |format|
      format.html { render 'reset_password' }
    end
  end

  def send_account_activation_mail(user)
    @user, @url = user, account_activation_users_url(token: user.account_activation_token)
    mail(to: user.email, subject: "verification mail to confirm account") do |format|
      format.html { render 'account_activation' }
    end
  end

  def send_transaction_confirmation_mail(transaction)
    set_instance_variables(transaction)
    mail(to: transaction.stripeEmail, subject: "Payment Confirmation mail") do |format|
      format.html { render 'payment_confirmation' }
    end
  end

  def send_project_cancelation_mail(transaction)
    set_instance_variables(transaction)
    mail(to: @user.email, subject: 'Transaction Cancelled') do |format|
      format.html { render 'payment_cancellation' }
    end
  end

  private

  def set_instance_variables(transaction)
    @transaction, @user, @project = transaction, transaction.user, transaction.project
  end

end
