class ChangeDocuments < ActiveRecord::Migration
  def change
    change_table :documents do |t|
      t.remove :attachment
    end
  end
end
