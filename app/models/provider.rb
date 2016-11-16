class Provider < ActiveRecord::Base
  belongs_to :city
  has_many :purchases, dependent: :nullify

  validates_presence_of :rut, :nombre, :direccion, :numero, :city_id, :email, :telefono, message: "no puede estar en blanco"
  validates_uniqueness_of :rut, :email, message: "esta en uso"

  validates :email, email_format: { message: "No es un formato valido" }
  validates_format_of :rut,
                      :with => /\A(\d{1,3})\.(\d{1,3})\.(\d{1,3})\-(k|\d{1})\Z/i,
                      :message => "no válido."

end
