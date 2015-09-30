class CreateSections < ActiveRecord::Migration
  def change
    create_table :sections do |t|
      t.string :description
      t.references :doc, index: true, foreign_key: true
      t.references :para, polymorphic: true
    end
  end
end
