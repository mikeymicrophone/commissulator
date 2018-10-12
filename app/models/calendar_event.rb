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
  
  def CalendarEvent.create_from_google event
    calendar_event = new
    calendar_event.title = event.title
    calendar_event.description = event.description
    calendar_event.location = event.location
    calendar_event.start_time = DateTime.parse event.start_time
    calendar_event.end_time = DateTime.parse event.end_time
    calendar_event.invitees = event.attendees.map { |attendee| attendee['email'] }.inspect
    calendar_event.google_id = event.id
    calendar_event.save
  end
  
  def google_calendar agent
    Google::Calendar.new({:calendar => agent.google_calendar_id}, google_connection(agent.google_tokens['refresh_token']))
  end
  
  def google_connection token
    if Rails.env.production?
      Google::Connection.factory(
        :client_id => Rails.application.credentials.google[:client_id],
        :client_secret => Rails.application.credentials.google[:client_secret],
        :refresh_token => token,
        :redirect_url  => url_helpers.avatar_google_oauth2_omniauth_callback_url
      )
    else
      Google::Connection.factory(
        :client_id => Rails.application.credentials.google[:staging_client_id],
        :client_secret => Rails.application.credentials.google[:staging_client_secret],
        :refresh_token => token,
        :redirect_url  => url_helpers.avatar_google_oauth2_omniauth_callback_url
      )
    end
  end
  
  def microsoft_calendar
    microsoft_connection.get_events Agent.find(31).cookies.last.download
  end
  
  def microsoft_connection
    RubyOutlook::Client.new
  end

  memoize :google_calendar, :google_connection, :microsoft_calendar, :microsoft_connection
end
