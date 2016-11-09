class CreateShips < ActiveRecord::Migration
  def change
    create_table :ships do |t|
      t.string :nombre
      t.string :patente
      t.integer :metros

      t.timestamps null: false
    end
  end
end
