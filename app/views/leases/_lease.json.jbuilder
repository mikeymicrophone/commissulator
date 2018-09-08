json.extract! lease, :id, :apartment_number, :street_number, :street_name, :zip_code, :landlord_id, :client_id, :registration_id, :created_at, :updated_at
json.url lease_url(lease, format: :json)
