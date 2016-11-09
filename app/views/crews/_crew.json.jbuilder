json.extract! crew, :id, :nombre, :apaterno, :amaterno, :email, :rut, :celular, :direccion, :city_id, :position_id, :ship_id, :created_at, :updated_at
json.url crew_url(crew, format: :json)