require 'rails_helper'

#FIXME_T No need to specify type: :model
describe Profile, type: :model do

  let(:profile) { build(:profile) }
  describe 'Constants' do
    #FIXME_T Also check Profile has REQUIRED_ATTRIBUTES constant or not
    it { expect(Profile::REQUIRED_ATTRIBUTES).to eq([:current_address, :permanent_address, :permanent_account_number, :phone_no]) }
  end

  #FIXME_T Specs for database columns missing
    # describe 'Database Columns' do
    # end

  describe "Associations" do
    #FIXME_T Use new syntax avoid using 'should' use 'expect'
    it { should belong_to(:user) }
  end

  describe "Validations" do
    #FIXME_T Spec for allow_nil missing
    it { is_expected.to validate_length_of(:permanent_account_number).is_equal_to(10) }

    #FIXME_T Use new syntax avoid using 'should' use 'expect'
    #FIXME_T Spec for allow_nil missing
    it { should allow_value("1234567823").for(:phone_no) }
    it { should_not allow_value("dadsfs").for(:phone_no) }
    it { should_not allow_value("124455").for(:phone_no) }
  end

  describe "Instance methods" do
    describe "complete?" do

      #FIXME_T Please write the spec for negative case too
      it { expect(profile.complete?).to be true }
    end
  end


end
