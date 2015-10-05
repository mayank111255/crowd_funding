require 'rails_helper'

describe Profile, type: :model do

  let(:profile) { build(:profile) }
  describe 'Constants' do
    it { expect(Profile::REQUIRED_ATTRIBUTES).to eq([:current_address, :permanent_address, :permanent_account_number, :phone_no]) }
  end

  describe "Associations" do
    it { should belong_to(:user) }
  end

  describe "Validations" do
    it { is_expected.to validate_length_of(:permanent_account_number).is_equal_to(10) }
    it { should allow_value("1234567823").for(:phone_no) }
    it { should_not allow_value("dadsfs").for(:phone_no) }
    it { should_not allow_value("124455").for(:phone_no) }
  end

  describe "Instance methods" do
    describe "complete?" do
      it { expect(profile.complete?).to be true }
    end
  end


end