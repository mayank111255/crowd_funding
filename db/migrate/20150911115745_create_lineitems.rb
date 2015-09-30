class CreateLineitems < ActiveRecord::Migration
  def change
    create_table :lineitems do |t|
      t.references :order
      t.integer :quantity

      t.timestamps null: false
    end
  end
end
