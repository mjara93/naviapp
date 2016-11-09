class CreateCosts < ActiveRecord::Migration
  def change
    create_table :costs do |t|
      t.integer :alimentacion
      t.integer :combustible
      t.integer :personal
      t.integer :emergencia
      t.references :trip, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
