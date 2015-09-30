class ChangeUser < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.remove :image
    end
  end
end
