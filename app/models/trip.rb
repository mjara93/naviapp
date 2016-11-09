class Trip < ActiveRecord::Base
  belongs_to :ship
  belongs_to :purchase
end
