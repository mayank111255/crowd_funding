class Profile < ActiveRecord::Base
  REQUIRED_ATTRIBUTES = [:current_address, :permanent_address, :permanent_account_number, :phone_no]

  belongs_to :user
  validates :phone_no, format: { with: PHONE_NO_REGEXP }, allow_nil: true
  validates :permanent_account_number, length: { is: 10 }, allow_nil: true

  def complete?
    REQUIRED_ATTRIBUTES.all? { |attribute| send(attribute).present? }
  end

end