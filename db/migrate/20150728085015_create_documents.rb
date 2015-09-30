class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.references :attachable, polymorphic: true, index: true
      t.string :attachable_subtype
      t.binary :attachment, null: false
      t.string :attachment_file_name, null: false
      t.string :attachment_content_type
      t.integer :attachment_file_size
      t.datetime :attachment_updated_at

      t.timestamps null: false
    end
  end
end
