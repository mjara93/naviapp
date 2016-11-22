class Api::LocationsController < ApplicationController
  before_action :set_location, only: [:show, :update, :destroy]

  def index
    @locations = Location.all
    render json: @locations
  end
  def informacion
    @trips = Trip.where("trips.real IS NULL").joins("join ships on ships.id = trips.ship_id join crews on crews.ship_id = ships.id join accounts on accounts.crew_id = crews.id").select("accounts.id as id, trips.id as trip_id, trips.salida as fecha_salida")
    render json: @trips
  end
  def show
  end
  def update_real
    fecha = DateTime.now;
    trip_id = params[:trip_id].to_i
    trip_changes = Trip.find(trip_id)
    trip_changes.real = fecha;
    trip_changes.save
  end
  def upload
    latitud = params[:lat].to_f
    longitud = params[:lon].to_f
    hora = DateTime.now.strftime('%Y-%m-%d %I:%M:%S')
    trip_id = params[:trip_id].to_i
    locations = Location.new(:latitud => latitud, :longitud => longitud, :hora => hora, :trip_id => trip_id)
    locations.save
  end
  def create
    @location = Location.new(location_params)

    if @location.save
      render json: @location, status: :created
    else
      render json: @location.errors, status: :unprocessable_entity
    end
  end

  def update
    if @location.update(location_params)
      render json: @location, status: :ok
    else
      render json: @location.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @location.destroy
    head :no_content
  end


  private
    def set_location
      @location = Location.find(params[:id])
    end

    def location_params
      params.require(:location).permit(:longitud, :latitud, :hora, :trip_id)
    end
end
