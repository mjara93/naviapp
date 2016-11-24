class TripsController < ApplicationController
  before_action :set_trip, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  # GET /trips
  # GET /trips.json
  def index
    @trips = Trip.all
  end

  # GET /trips/1
  # GET /trips/1.json
  def show
    get_id = params[:id]
    @compra = Purchase.where(id: @trip.purchase)
    datos = Location.where("locations.id = "+get_id)
    @salida = '{"lat": -40.580605913913, "lng": -73.1111920951491, "infowindow": "2016-11-22T10:48:06.000Z"}'
    #datos.each do |datos|
    #  longitud = datos.longitud
    #  latitud = datos.latitud
    #  hora = datos.hora
    #  @salida = @salida+'{"lat": '+latitud+', "lng": '+longitud+', "infowindow": "'+hora+'"},'      
    #end
  end

  # GET /trips/new
  def new
    @trip = Trip.new
    @trip.costs.build
  end

  # GET /trips/1/edit
  def edit
  end

  # POST /trips
  # POST /trips.json
  def create
    @trip = Trip.new(trip_params)

    respond_to do |format|
      if @trip.save
        format.html { redirect_to @trip, notice: 'Registro creado satisfactoriamente.' }
        format.json { render :show, status: :created, location: @trip }
      else
        format.html { render :new }
        format.json { render json: @trip.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /trips/1
  # PATCH/PUT /trips/1.json
  def update
    respond_to do |format|
      if @trip.update_attributes(trip_params)
        format.html { redirect_to @trip, notice: 'Registro actualizado satisfactoriamente.' }
        format.json { render :show, status: :ok, location: @trip }
      else
        format.html { render :edit }
        format.json { render json: @trip.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /trips/1
  # DELETE /trips/1.json
  def destroy
    @trip.destroy
    respond_to do |format|
      format.html { redirect_to trips_url, notice: 'Registro eliminado satisfactoriamente.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_trip
      @trip = Trip.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def trip_params
      params.require(:trip).permit(:salida, :real, :estimada, :motivo, :ship_id, :purchase_id, costs_attributes: [:id, :alimentacion, :combustible, :personal, :emergencia])
    end
end
