json.extract! social_account, :id, :variety, :url, :moniker, :client_id, :employer_id, :created_at, :updated_at
json.url social_account_url(social_account, format: :json)
