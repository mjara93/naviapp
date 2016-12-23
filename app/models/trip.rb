class Trip < ActiveRecord::Base
  belongs_to :ship
  belongs_to :purchase
  has_many :costs, dependent: :destroy
  has_many :locations, dependent: :destroy
  accepts_nested_attributes_for :costs, :allow_destroy => true

validates_presence_of :salida, :estimada, :motivo, :ship_id, :purchase_id, message: "no puede estar en blanco"
validates_uniqueness_of :purchase_id, message: "esta en uso"

validate :validates_fecha
validate :validate_estimada
  #validates_each :salida, :estimada do |model, attr, value|
  #  if value.to_datetime < 1.day.ago.to_s
  #    model.errors.add(attr, "la fecha #{value} no puede ser menor a la actual")
  #  end
  #end
  #validates_each :estimada do |model, attr, value|
  #  if value.to_datetime <= :salida.value
  #    model.errors.add(attr, "la fecha #{value} no puede ser menor que la salida")
  #  end
  #end
def validates_fecha
  if salida.to_datetime < Date.current.to_s
    errors.add(:message, "la fecha #{salida} no puede ser menor a la fecha actual")
  end
end

def validate_estimada
  if estimada.to_datetime <= salida.to_datetime
    errors.add(:message, "la fecha estimada no puede ser menor o igual a la fecha de salida")
  end
end
end
