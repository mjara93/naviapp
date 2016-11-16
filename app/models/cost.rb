class Cost < ActiveRecord::Base
  belongs_to :trip
  validates_presence_of :alimentacion, :combustible, :personal, :emergencia, message: "no puede estar en blanco"

end
