class CreateCities < ActiveRecord::Migration
  def change
    create_table :cities do |t|
      t.string :nombre

      t.timestamps null: false
    end
  end
end
