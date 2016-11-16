class Sale < ActiveRecord::Base
  belongs_to :client
  has_many :details, dependent: :destroy
  accepts_nested_attributes_for :details

  validates_presence_of :factura, :fecha, :total, :client_id, message: "no puede estar en blanco"
  validates_uniqueness_of :factura, message: "esta en uso"
end
