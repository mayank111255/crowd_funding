class CreateDocs < ActiveRecord::Migration
  def change
    create_table :docs do |t|
      t.string :name
    end
  end
end
