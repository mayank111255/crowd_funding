class AddColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :reset_password_token, :string
    add_column :users, :reset_password_token_generated_at, :timestamp
  end
end
