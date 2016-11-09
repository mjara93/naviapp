json.extract! sale, :id, :factura, :fecha, :total, :client_id, :created_at, :updated_at
json.url sale_url(sale, format: :json)