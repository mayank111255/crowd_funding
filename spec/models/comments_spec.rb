require 'rails_helper'

describe Comment, type: :model do
  
  describe "Associations" do
	it { should belong_to(:user) }
	it { should belong_to(:project) }
  end

end