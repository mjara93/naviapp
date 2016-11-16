json.array!(@boats) do |boat|
  json.extract! boat, :id, :nombre, :patente, :metros
  json.url boat_url(boat, format: :json)
end
