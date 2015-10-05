require 'rails_helper'

describe Document, type: :model do

  describe "Constants" do
    it { expect(Document::SUBTYPES).to eq([:current_address, :permanent_address, :PAN]) }
  end

  describe "Associations" do
    it { should belong_to(:attachable) }
  end

  describe "Attachments" do
    it { should have_attached_file(:attachment) }

    context "Validations" do
      it { should validate_attachment_presence(:attachment) }
      it { should validate_attachment_content_type(:attachment).
              allowing("attachment/pdf", "attachment.doc", "image/jpeg") }
    end
  end


end
