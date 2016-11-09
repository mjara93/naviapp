class CreateSummaries < ActiveRecord::Migration
  def change
    create_table :summaries do |t|
      t.float :cantidad
      t.integer :precio
      t.integer :subtotal
      t.references :product, index: true, foreign_key: true
      t.references :purchase, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
