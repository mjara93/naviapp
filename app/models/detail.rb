class Detail < ActiveRecord::Base
  belongs_to :product
  belongs_to :sale

  validates_presence_of :product_id, :cantidad, :precio, :subtotal, message: "no puede estar en blanco"
end
