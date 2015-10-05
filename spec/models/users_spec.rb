require 'rails_helper'

#FIXME_T No need to specify type: :model
#FIXME_T Indentation Issues

describe User, :type => :model do

  let(:user){ build(:user) }
  let(:profile_attrs) { { current_address: 'current',
                          permanent_address: 'permanent',
                          permanent_account_number: '1234567890',
                          phone_no: '1234567890'
                        }
                      }

  describe 'constants' do
    #FIXME_T Also check User has DEFAULT_DOCUMENTS_COUNT constant or not
    it { expect(User::DEFAULT_DOCUMENTS_COUNT).to eq(3) }
  end

  describe "Associations" do
    #FIXME_T Test case for dependent destroy missing for profile
    it { is_expected.to have_one(:profile) }
    it { is_expected.to have_many(:documents).dependent(:destroy) }
    it { is_expected.to have_many(:projects).dependent(:destroy) }
    it { is_expected.to have_many(:comments).dependent(:destroy) }
    it { is_expected.to have_many(:transactions) }
    it { is_expected.to have_and_belong_to_many(:friends).class_name('User') }#.join_table('friends') }
  end

  describe 'Accept Nested Attributes' do
    it { is_expected.to accept_nested_attributes_for(:profile) }
    it { is_expected.to accept_nested_attributes_for(:documents) }
  end

  describe "Attachments" do
    #FIXME_T Use new syntax avoid using 'should' use 'expect'
    #FIXME_T Test cases for it's styles and other options missing
    it { should have_attached_file(:image) }

    context "validations" do
      #FIXME_T Use new syntax avoid using 'should' use 'expect'
      it { should validate_attachment_content_type(:image).allowing('image/jpeg') }
    end
  end

  describe "Secure Password" do
    it { is_expected.to have_secure_password }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:password).on(:update) }
    it { is_expected.to validate_presence_of(:password_confirmation) }
    it { is_expected.to validate_length_of(:password).is_at_least(8) }
  end

  describe "Callbacks" do
    it { is_expected.to callback(:set_defaults).before(:create).unless(:role?) }
    it { is_expected.to callback(:send_mail).after(:save).if(:token_type)}
    it { is_expected.to callback(:nullify_password_tokens).before(:save).if(:is_password_changed)}
  end

  describe "Attribute" do
    context "Accessors" do
      before do
        user.token_type = "test_token"
        user.account_updation = true
        user.is_password_changed = true
      end
      it { expect(user.token_type).to eq("test_token") }
      it { expect(user.account_updation).to be_truthy }
      it { expect(user.is_password_changed).to be_truthy }
    end
  end

  describe "Delegations" do
    it { is_expected.to delegate_method(:phone_no).to(:profile) }
    it { is_expected.to delegate_method(:permanent_address).to(:profile) }
    it { is_expected.to delegate_method(:current_address).to(:profile) }
    it { is_expected.to delegate_method(:permanent_account_number).to(:profile) }
  end

  describe 'scopes' do
    it 'load users' do
      expected = User.where(role: :user).first(4)
      expect(User.load_users(4,1)).to eq(expected)
    end

    it 'count all users' do
      expected = User.where(role: :user).count
      expect(User.count_all_users).to eq(expected)
    end
  end

  context 'instance methods' do
    describe 'nullify_password_tokens' do
      before do
        user.reset_password_token = "fdsfdsfds"
        user.reset_password_token_generated_at = Time.now
        user.nullify_password_tokens
      end
      it { expect(user.reset_password_token).to be_nil }
      it { expect(user.reset_password_token_generated_at).to be_nil }
    end

    describe 'update password' do
      before do
        @password = '123456123456'
        user.update_password({password: @password})
      end
      it do
        expect(user.is_password_changed).to be false
        expect(user.authenticate(@password)).to be_truthy
      end
    end

    describe 'generate reset password tokens' do
      before do
        user.token_type, user.reset_password_token, user.reset_password_token_generated_at = nil
        user.generate_reset_password_token
      end
      it do
        expect(user.token_type).to eq('reset_password')
        expect(user.reset_password_token).to_not be_nil
        expect(user.reset_password_token_generated_at).to_not be_nil
        expect(user.persisted?).to be true
      end
    end

    describe 'generate account activation token' do
      before do
        user.token_type, user.account_activation_token, user.account_activation_token_generated_at = nil
        user.generate_account_activation_token
      end
      it do
        expect(user.token_type).to eq('account_activation')
        expect(user.account_activation_token).to_not be_nil
        expect(user.account_activation_token_generated_at).to_not be_nil
        expect(user.persisted?).to be true
      end
    end

    describe 'update account' do
      before do
        @name = 'mayan'
        update_params = { name: @name }
        user.update_account(update_params)
      end
      it { expect(user.name).to eq(@name) }
    end

    describe 'build associated objects' do
      before do
        user.profile, user.documents = nil, []
        user.build_associated_objects
      end
      it do
        expect(user.profile).to_not be_nil
        expect(user.documents.length).to eq(User::DEFAULT_DOCUMENTS_COUNT)
      end
    end

    describe "check if profile is completed" do
      before { user.profile, user.documents = nil, [] }
      it { expect(user.profile_complete?).to be false }

      it do
        user.build_associated_objects
        user.build_profile(profile_attrs)
        expect(user.profile_complete?).to be true
      end
    end

    describe "contributions" do
      before { @contributions = user.transactions }
      it { expect(user.contributions).to eq(@contributions)}
    end
# mail testing??
    context "private methods" do
      describe "set defaults" do
        before { user.send(:set_defaults) }
        it { expect(user.role).to eq('user') }
      end
      describe "generate token" do
        it { expect(user.send(:generate_token).length).to eq(2) }
      end
    end

  end
end
