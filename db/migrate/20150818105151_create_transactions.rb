class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.references :user, index: true, foreign_key: true, null: false
      t.references :project, index: true, foreign_key: true, null: false
      t.integer :amount
      t.string :mode
      t.string :status
      t.string :stripeEmail
      t.string :stripeToken

      t.timestamps null: false
    end
  end
end
