class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.string :rut
      t.text :nombre
      t.integer :telefono
      t.string :direccion
      t.integer :numero
      t.references :city, index: true, foreign_key: true
      t.string :email

      t.timestamps null: false
    end
  end
end
