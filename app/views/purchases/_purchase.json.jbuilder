json.extract! purchase, :id, :fecha, :factura, :total, :provider_id, :created_at, :updated_at
json.url purchase_url(purchase, format: :json)