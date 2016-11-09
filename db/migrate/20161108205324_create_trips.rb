class CreateTrips < ActiveRecord::Migration
  def change
    create_table :trips do |t|
      t.date :salida
      t.date :real
      t.date :estimada
      t.string :motivo
      t.references :ship, index: true, foreign_key: true
      t.references :purchase, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
