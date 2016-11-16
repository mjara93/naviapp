class Purchase < ActiveRecord::Base
  belongs_to :provider
  has_many :summaries, dependent: :destroy
  accepts_nested_attributes_for :summaries, allow_destroy: true,
                              reject_if: ->(attrs) { attrs['product_id'].blank? || attrs['cantidad'].blank? || attrs['precio'].blank? || attrs['subtotal'].blank?}

  validates_presence_of :fecha, :factura, :total, :provider_id, message: "no puede estar en blanco"


end
