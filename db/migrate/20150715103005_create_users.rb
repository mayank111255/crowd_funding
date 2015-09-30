class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :password_digest, null: false
      t.string :role, null: false
      t.boolean :is_activated, default: false
      t.binary :image
      t.string :image_file_name
      t.string :image_content_type
      t.float :image_file_size
      t.timestamp :image_updated_at

      t.timestamps null: false
    end
    add_index :users, :email, unique: true
  end
end
