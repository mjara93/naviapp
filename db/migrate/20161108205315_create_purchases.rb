class CreatePurchases < ActiveRecord::Migration
  def change
    create_table :purchases do |t|
      t.date :fecha
      t.integer :factura
      t.integer :total
      t.references :provider, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
