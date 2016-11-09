class CreateProviders < ActiveRecord::Migration
  def change
    create_table :providers do |t|
      t.string :rut
      t.text :nombre
      t.string :direccion
      t.integer :numero
      t.references :city, index: true, foreign_key: true
      t.string :email
      t.integer :telefono

      t.timestamps null: false
    end
  end
end
