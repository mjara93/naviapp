class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :nombre
      t.integer :stock

      t.timestamps null: false
    end
  end
end
