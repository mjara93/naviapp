class CreateSales < ActiveRecord::Migration
  def change
    create_table :sales do |t|
      t.integer :factura
      t.date :fecha
      t.integer :total
      t.references :client, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
