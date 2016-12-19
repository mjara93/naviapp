class Sale < ActiveRecord::Base
  belongs_to :client
  has_many :details, dependent: :destroy
  accepts_nested_attributes_for :details, allow_destroy: true,
                              reject_if: ->(attrs) { attrs['product_id'].blank? || attrs['cantidad'].blank? || attrs['precio'].blank? || attrs['subtotal'].blank?}

  validates_presence_of :factura, :fecha, :total, :client_id, message: "no puede estar en blanco"
  validates_uniqueness_of :factura, message: "esta en uso"

  validate :validates_product_stock

  def validates_product_stock
    details.each do |detail|
      @product = Product.find(detail.product_id)
      if detail.cantidad > @product.stock
        errors.add(:message, "no hay stock suficiente del producto #{@product.nombre}")
      end
    end
  end
end
