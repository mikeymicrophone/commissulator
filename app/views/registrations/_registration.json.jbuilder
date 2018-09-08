json.extract! registration, :id, :minimum_price, :maximum_price, :size, :move_by, :reason_for_moving, :occupants, :pets, :referral_source_id, :agent_id, :created_at, :updated_at
json.url registration_url(registration, format: :json)
