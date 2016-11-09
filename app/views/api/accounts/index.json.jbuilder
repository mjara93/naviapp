json.array! @accounts do |account|
  json.(account, :id, :email, :contraseña, :crew_id)
end
