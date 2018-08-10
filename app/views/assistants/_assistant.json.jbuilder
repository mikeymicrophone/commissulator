json.extract! assistant, :id, :first_name, :last_name, :phone_number, :email, :status, :created_at, :updated_at
json.url assistant_url(assistant, format: :json)
