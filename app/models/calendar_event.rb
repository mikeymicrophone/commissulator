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
    if Rails.env.production?
      Google::Calendar.get(:client_id => Rails.application.credentials.google[:client_id],
        :client_secret => Rails.application.credentials.google[:client_secret],
        :calendar      => ENV['GOOGLE_CALENDAR_ID'],
        :redirect_url  => "urn:ietf:wg:oauth:2.0:oob") # this is what Google uses for 'applications'
    else
      Google::Calendar.get(:client_id => Rails.application.credentials.google[:staging_client_id],
        :client_secret => Rails.application.credentials.google[:staging_client_secret],
        :calendar      => ENV['GOOGLE_CALENDAR_ID'],
        :redirect_url  => "urn:ietf:wg:oauth:2.0:oob") # this is what Google uses for 'applications'
    end
  end
  memoize :google_calendar
end
