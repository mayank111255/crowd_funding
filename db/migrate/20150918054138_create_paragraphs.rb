class CreateParagraphs < ActiveRecord::Migration
  def change
    create_table :paragraphs do |t|
      t.string :content
      # t.references :section, index: true, foreign_key: true
    end
  end
end
