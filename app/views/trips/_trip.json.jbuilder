json.extract! trip, :id, :salida, :real, :estimada, :motivo, :ship_id, :purchase_id, :created_at, :updated_at
json.url trip_url(trip, format: :json)