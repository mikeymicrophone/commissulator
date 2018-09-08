json.extract! apartment, :id, :unit_number, :street_number, :street_name, :zip_code, :size, :rent, :comment, :registration_id, :created_at, :updated_at
json.url apartment_url(apartment, format: :json)
