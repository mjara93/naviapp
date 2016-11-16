json.extract! client, :id, :rut, :nombre, :telefono, :direccion, :numero, :city_id, :email, :created_at, :updated_at
json.url client_url(client, format: :json)
