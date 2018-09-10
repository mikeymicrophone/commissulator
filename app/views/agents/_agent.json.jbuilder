json.extract! agent, :id, :first_name, :last_name, :phone_number, :email, :status, :created_at, :updated_at
json.url agent_url(agent, format: :json)
