class Client < ActiveRecord::Base
  belongs_to :city
  has_many :sales, dependent: :destroy

  validates_presence_of :rut, :nombre, :telefono, :direccion, :numero, :city_id, :email, message: "no puede estar en blanco"
  validates_uniqueness_of :rut, :email, message: "esta en uso"
  validates_format_of :rut,
                      :with => /\A(\d{1,3})\.(\d{1,3})\.(\d{1,3})\-(k|\d{1})\Z/i,
                      :message => "no válido."
validates :email, email_format: { message: "No es un formato valido" }

end
