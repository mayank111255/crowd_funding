require 'rails_helper'

#FIXME_T No need to specify type: :model
describe Document, type: :model do

  describe "Constants" do
    #FIXME_T Also check Document has SUBTYPES constant or not
    it { expect(Document::SUBTYPES).to eq([:current_address, :permanent_address, :PAN]) }
  end

  #FIXME_T Specs for database columns missing
    # describe 'Database Columns' do
    # end

  describe "Associations" do
    #FIXME_T Use new syntax avoid using 'should' use 'expect'
    it { should belong_to(:attachable) }
  end

  describe "Attachments" do
    #FIXME_T Use new syntax avoid using 'should' use 'expect'
    #FIXME_T Test cases for it's styles and other options missing
    it { should have_attached_file(:attachment) }


    context "Validations" do
      #FIXME_T Use new syntax avoid using 'should' use 'expect'
      it { should validate_attachment_presence(:attachment) }
      it { should validate_attachment_content_type(:attachment).
              allowing("attachment/pdf", "attachment.doc", "image/jpeg") }
    end
  end


end
