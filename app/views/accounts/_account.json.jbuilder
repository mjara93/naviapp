json.extract! account, :id, :email, :contraseña, :crew_id, :created_at, :updated_at
json.url account_url(account, format: :json)