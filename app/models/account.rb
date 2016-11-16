class Account < ActiveRecord::Base
  belongs_to :crew
  validates_presence_of :email, :contraseña, :crew_id, message: "no puede estar en blanco"
  validates_uniqueness_of :email, :crew_id, "esta en uso"

end
