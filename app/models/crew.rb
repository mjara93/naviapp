class Crew < ActiveRecord::Base
  validates_presence_of :nombre, :apaterno, :amaterno, :email, :rut, :celular, :direccion, :city_id, :ship_id, :position_id, message: "no puede estar en blanco"
  validates_uniqueness_of :email, :rut, message: "esta en uso"
  validates_format_of :rut,
                      :with => /\A(\d{1,3})\.(\d{1,3})\.(\d{1,3})\-(k|\d{1})\Z/i,
                      :message => "no válido."
  validates :email, email_format: { message: "No es un formato valido" }

  belongs_to :city
  belongs_to :position
  belongs_to :ship
  has_many :accounts, dependent: :destroy
end
