class Ship < ActiveRecord::Base
  validates_presence_of :nombre, :patente, :metros, message: "no puede estar en blanco"
	#valida que el campo no este en la BD
	validates_uniqueness_of :nombre, :patente, message: "esta en uso"

  has_many :crews
	has_many :trips
  has_many :locations
  
end
