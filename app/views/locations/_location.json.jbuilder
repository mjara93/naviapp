json.extract! location, :id, :longitud, :latitud, :hora, :trip_id, :created_at, :updated_at
json.url location_url(location, format: :json)