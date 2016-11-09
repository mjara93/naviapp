class Api::CrewsController < ApplicationController
  before_action :set_crew, only: [:show, :update, :destroy]

  def index
    @crews = Crew.all
    render json: @crews
  end

  def show
  end

  def create
    @crew = Crew.new(crew_params)

    if @crew.save
      render json: @crew, status: :created
    else
      render json: @crew.errors, status: :unprocessable_entity
    end
  end

  def update
    if @crew.update(crew_params)
      render json: @crew, status: :ok
    else
      render json: @crew.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @crew.destroy
    head :no_content
  end


  private
    def set_crew
      @crew = Crew.find(params[:id])
    end

    def crew_params
      params.require(:crew).permit(:nombre, :apaterno, :amaterno, :email, :rut, :celular, :direccion, :city_id, :position_id, :ship_id)
    end
end
