class CalendarEvent < ApplicationRecord
  extend Memoist
  
  belongs_to :agent, :optional => true
  
  def push_to_google
    google_event = CalendarEvent.google_calendar(agent).create_event do |e|
      e.attendees = invitees
      e.title = title
      e.description = description
      e.location = location
      e.start_time = start_time
      e.end_time = end_time
    end
    update_attribute :google_id, google_event.id
  end
  
  def retrieve_invitee_emails
    updated_invitees = invitees.map do |invitee|
      unless invitee['email'].present?
        fub_person = FubClient::Person.where(:name => invitee['name']).fetch.first
        invitee['email'] = fub_person&.emails&.first&.[]('value')
      end
      invitee
    end
    update_attribute :invitees, updated_invitees
  end
  
  def agent_is_invitee
    updated_invitees = invitees
    unless invitees.map { |invitee| invitee['name'] }.include? agent.name
      updated_invitees << {:name => agent.name, :email => agent.email}
    end
    unless updated_invitees.select { |invitee| invitee['name'] == agent.name }.first['email'].present?
      agent_invitee = updated_invitees.select { |invitee| invitee['name'] == agent.name }.first
      agent_invitee['email'] = agent.email
      updated_invitees = updated_invitees.reject { |invitee| invitee['name'] == agent.name }
      updated_invitees << agent_invitee
    end
    update_attribute :invitees, updated_invitees
  end
  
  def CalendarEvent.create_from_google event, agent
    calendar_event = new
    calendar_event.title = event.title
    calendar_event.description = event.description
    calendar_event.location = event.location
    calendar_event.start_time = DateTime.parse event.start_time
    calendar_event.end_time = DateTime.parse event.end_time
    calendar_event.invitees = event.attendees
    calendar_event.google_id = event.id
    calendar_event.agent = agent
    calendar_event.save
    calendar_event
  end
  
  def CalendarEvent.find_or_create_from_google event, agent
    create_from_google event, agent unless CalendarEvent.where(:google_id => event.id).present?
  end
  
  def push_to_follow_up_boss fub_calendar_event = nil
    unless fub_calendar_event
      fub_calendar_event = FubCalendarEvent.new
      fub_calendar_event.agent = agent
      fub_calendar_event.load_cookie
      fub_calendar_event.access_calendar_page
    end
    fub_calendar_event.access_event_input_form
    guest_names = invitees.map do |invitee|
      FubClient::Person.where(:email => invitee['email']).fetch.first&.name
    end
    fub_calendar_event.add_event self, guest_names
  end
  
  def CalendarEvent.google_calendar agent
    Google::Calendar.new({:calendar => agent.google_calendar_id}, google_connection(agent.google_tokens))
  end
  
  def CalendarEvent.google_connection tokens
    if Rails.env.production?
      Google::Connection.factory(
        :client_id => Rails.application.credentials.google[:client_id],
        :client_secret => Rails.application.credentials.google[:client_secret],
        :refresh_token => tokens['refresh_token'],
        :access_token => tokens['access_token'],
        :redirect_url  => url_helpers.avatar_google_oauth2_omniauth_callback_url
      )
    else
      Google::Connection.factory(
        :client_id => Rails.application.credentials.google[:staging_client_id],
        :client_secret => Rails.application.credentials.google[:staging_client_secret],
        :refresh_token => tokens['refresh_token'],
        :access_token => tokens['access_token'],
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
end
