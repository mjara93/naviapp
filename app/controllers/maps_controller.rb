class MapsController < ApplicationController
  before_action :authenticate_user!

  def index
        @viaje = Trip.where(real: nil)
        @boat = Location.where(trip_id: @viaje)

        @hash = Gmaps4rails.build_markers(@boat) do |boat, marker|
        marker.lat boat.latitud
        marker.lng boat.longitud
        marker.infowindow boat.trip.motivo
        marker.picture({
          "url": "http://download.seaicons.com/icons/manda-pie/nautical/48/Boat-red-icon.png",
          "width":  48,
          "height": 48
        })
      end
  end
end
