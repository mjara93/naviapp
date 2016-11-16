class Position < ActiveRecord::Base
  validates_presence_of :nombre, message: "no puede estar en blanco"
  validates_presence_of :nombre, message: "esta en uso"
end
