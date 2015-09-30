class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.references :user, index: {unique: true}, foreign_key: true, null: false
      t.integer :phone_no
      t.string :permanent_address
      t.string :current_address
      t.string :PAN, limit: 10

      t.timestamps null: false
    end
  end
end
