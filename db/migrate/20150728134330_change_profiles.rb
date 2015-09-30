class ChangeProfiles < ActiveRecord::Migration
  def change
    change_table :profiles do |t|
      t.rename :PAN, :permanent_account_number
    end
  end
end
