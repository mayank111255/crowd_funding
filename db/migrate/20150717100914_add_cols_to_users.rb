class AddColsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :account_activation_token, :string
    add_column :users, :account_activation_token_generated_at, :timestamp
  end
end
