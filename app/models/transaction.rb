class Transaction < ActiveRecord::Base
  belongs_to :user
  belongs_to :project

  after_create :send_confirmation_mail

  def refund
    Stripe::Refund.create(charge: charge_id) if charge_id
  end

private

  def send_confirmation_mail
    UserMailer.send_transaction_confirmation_mail(self).deliver_now
  end

end