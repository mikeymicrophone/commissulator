json.extract! tenant, :id, :client_id, :lease_id, :created_at, :updated_at
json.url tenant_url(tenant, format: :json)
