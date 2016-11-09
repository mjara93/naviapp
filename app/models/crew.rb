class Crew < ActiveRecord::Base
  belongs_to :city
  belongs_to :position
  belongs_to :ship
end
