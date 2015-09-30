class CreateFriends < ActiveRecord::Migration
  def change
    create_table :friends, id: false do |t|
      t.references :user, index: true, foreign_key: true
      t.integer :friend_id
    end
  end
end
