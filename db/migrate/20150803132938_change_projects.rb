class ChangeProjects < ActiveRecord::Migration
  def change
    change_table :projects do |t|
      t.rename :type, :kind
    end
  end
end
