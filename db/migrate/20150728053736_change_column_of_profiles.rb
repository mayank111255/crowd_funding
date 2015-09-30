class ChangeColumnOfProfiles < ActiveRecord::Migration
  def up
    change_column :profiles, :phone_no, :string
  end
  def down
    change_column :profiles, :phone_no, :integer
  end
end
