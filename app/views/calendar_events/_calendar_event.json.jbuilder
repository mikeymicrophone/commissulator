json.extract! calendar_event, :id, :title, :description, :start_time, :end_time, :invitees, :follow_up_boss_id, :google_id, :calendly_id, :agent_id, :confirmed_at, :created_at, :updated_at
json.url calendar_event_url(calendar_event, format: :json)
