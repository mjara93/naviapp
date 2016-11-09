class CreateCrews < ActiveRecord::Migration
  def change
    create_table :crews do |t|
      t.string :nombre
      t.string :apaterno
      t.string :amaterno
      t.string :email
      t.string :rut
      t.integer :celular
      t.string :direccion
      t.references :city, index: true, foreign_key: true
      t.references :position, index: true, foreign_key: true
      t.references :ship, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
