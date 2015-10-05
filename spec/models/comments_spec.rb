require 'rails_helper'

#FIXME_T No need to specify type: :model
describe Comment, type: :model do

  #FIXME_T Specs for database columns missing
    # describe 'Database Columns' do
    # end

  describe "Associations" do
  #FIXME_T Use new syntax avoid using 'should' use 'expect'
  #FIXME_T Indentation Issues

	it { should belong_to(:user) }
	it { should belong_to(:project) }
  end

end
