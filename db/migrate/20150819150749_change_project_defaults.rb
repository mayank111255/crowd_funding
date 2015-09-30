class ChangeProjectDefaults < ActiveRecord::Migration
  def change
    change_column :projects, :total_amount, :integer, null: true, default: 0
  end
end
