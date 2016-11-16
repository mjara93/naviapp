class City < ActiveRecord::Base
  has_many :providers
  validates_presence_of :nombre, message: "no puede estar en blanco"
end
