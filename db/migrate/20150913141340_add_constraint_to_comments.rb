class AddConstraintToComments < ActiveRecord::Migration
  def up
  	change_column :comments, :user_id, :integer, foreign_key: true,null: true
  end
  def down
  	change_column :comments, :user_id, :integer, foreign_key: true
  end
end
