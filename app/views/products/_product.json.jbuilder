json.extract! product, :id, :nombre, :stock, :created_at, :updated_at
json.url product_url(product, format: :json)