class CreateJoinTable < ActiveRecord::Migration
  def change
    create_join_table :users, :roles do |t|
    	t.primary_key :id
      t.index [:user_id, :role_id]
      t.index [:role_id, :user_id]
    end
  end
end
