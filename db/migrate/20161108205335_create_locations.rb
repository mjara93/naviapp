class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.float :longitud
      t.float :latitud
      t.datetime :hora
      t.references :trip, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
