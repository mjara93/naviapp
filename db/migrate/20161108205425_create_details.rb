class CreateDetails < ActiveRecord::Migration
  def change
    create_table :details do |t|
      t.float :cantidad
      t.integer :precio
      t.integer :subtotal
      t.references :product, index: true, foreign_key: true
      t.references :sale, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
