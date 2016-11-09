class Detail < ActiveRecord::Base
  belongs_to :product
  belongs_to :sale
end
