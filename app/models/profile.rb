class Profile < ActiveRecord::Base
  REQUIRED_ATTRIBUTES = [:current_address, :permanent_address, :permanent_account_number, :phone_no]

  belongs_to :user
  validates :phone_no, format: { with: PHONE_NO_REGEXP }, if: :phone_no?
  validates :permanent_account_number, length: { is: 10 }, if: :permanent_account_number?
  # validates :phone_no, :current_address, :permanent_address, :permanent_account_number, presence: true, allow_blank: false

  def complete?
    REQUIRED_ATTRIBUTES.all? { |attribute| send(attribute).present? }
  end

end