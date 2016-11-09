json.extract! provider, :id, :rut, :nombre, :direccion, :numero, :ciudad_id, :email, :telefono, :created_at, :updated_at
json.url provider_url(provider, format: :json)