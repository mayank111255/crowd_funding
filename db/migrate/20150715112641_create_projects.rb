class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.references :user, index: true, foreign_key: true, null: false
      t.string :title, null: false
      t.string :type, null: false
      t.text :description, null: false
      t.date :end_date, null: false
      t.decimal :total_amount, null: false
      t.string :status, default: 'created'
      t.string :video_link

      t.timestamps null: false
    end
  end
end
