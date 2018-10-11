class CalendarEvent < ApplicationRecord
  extend Memoist
  
  belongs_to :agent, :optional => true
  
  def push_to_google
    google_calendar.create_event do |e|
      e.attendees = invitees.map { |invitee| {:name => invitee} }
      e.title = title
      e.description = description
      e.location = location
      e.start_time = start_time
      e.end_time = end_time
    end
  end
  
  def google_calendar
    google_connection.calendar.get ENV['GOOGLE_CALENDAR_ID']
  end
  
  def google_connection
    if Rails.env.production?
      Google::Connection.factory(
        :client_id => Rails.application.credentials.google[:client_id],
        :client_secret => Rails.application.credentials.google[:client_secret],
        :calendar      => ENV['GOOGLE_CALENDAR_ID'],
        :redirect_url  => 'url helpers in the model'
      )
    else
      Google::Connection.factory(
        :client_id => Rails.application.credentials.google[:staging_client_id],
        :client_secret => Rails.application.credentials.google[:staging_client_secret],
        :refresh_token => ENV['GOOGLE_CALENDAR_REFRESH_TOKEN'],
        :redirect_url  => 'http://localhost:3000/calendar_events/token'
      )
    end
  end

  memoize :google_calendar, :google_connection
end
