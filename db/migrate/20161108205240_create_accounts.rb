class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :email
      t.string :contraseña
      t.references :crew, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
