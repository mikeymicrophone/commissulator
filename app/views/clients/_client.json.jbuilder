json.extract! client, :id, :first_name, :last_name, :date_of_birth, :created_at, :updated_at
json.url client_url(client, format: :json)
