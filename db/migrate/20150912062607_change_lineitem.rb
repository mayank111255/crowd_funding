class ChangeLineitem < ActiveRecord::Migration
  def up
  	change_column :lineitems, :order_id, :integer, foreign_key: true
  end
  def down
  	change_column :lineitems, :order_id, :integer, null: true
  end
end
