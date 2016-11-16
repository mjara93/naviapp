class Product < ActiveRecord::Base
  validates_presence_of :nombre, :stock, message: "no puede estar en blanco"
  validates_uniqueness_of :nombre, message: "esta en uso"
  
end
