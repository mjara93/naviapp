class MainController < ApplicationController
  before_action :authenticate_user!
  def index
    @time = Date.current.to_s
    @personas = Crew.count
    @compras =  Purchase.count
    @ventas =  Sale.count
    @barcos = Ship.count
    @itinerario = Trip.where(real: nil).count
  end
end
