class CalendarEvent < ApplicationRecord
  extend Memoist
  include Sluggable
  
  belongs_to :agent, :optional => true

  def to_param
    basic_slug title
  end
  
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
  
  def determine_invitees
    if description =~ /Powered by Calendly/
      name_pattern = /([\w\s]+)\sand\s([\w\s]+)/
      matched_names = name_pattern.match title
      self.invitees ||= matched_names[1..-1].map { |name| {'name' => name} }
    end
  end
  
  def retrieve_invitee_details
    updated_invitees = invitees.map do |invitee|
      fub_person = FubClient::Person.where(:name => invitee['name']).fetch.first
      if fub_person
        invitee['person_id'] = fub_person.id
        invitee['email'] = fub_person&.emails&.first&.[]('value')
      else
        fub_user = FubClient::User.where(:name => invitee['name']).fetch.first
        invitee['user_id'] = fub_user&.id
        invitee['email'] = fub_user&.email
      end
      invitee
    end
    update_attribute :invitees, updated_invitees
  end
  
  def invitee_description
    "Invited: #{invitees.map { |invitee| invitee['name'] }.reject { |name| name == agent&.name }.to_sentence}\n\n"
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
    calendar_event.determine_invitees
    calendar_event.save
    calendar_event.retrieve_invitee_details
    calendar_event
  end
  
  def CalendarEvent.find_or_create_from_google event, agent
    create_from_google event, agent unless where(:google_id => event.id).present?
  end
  
  def CalendarEvent.create_from_follow_up_boss event
    calendar_event = new
    calendar_event.title = event.title
    calendar_event.invitees = event.invitees
    calendar_event.agent = Agent.where(:follow_up_boss_id => event.created_by_id).take
    calendar_event.description = calendar_event.invitee_description + event.description
    calendar_event.location = event.location
    Chronic.time_class = Time.zone
    calendar_event.start_time = Chronic.parse event.start
    calendar_event.end_time = Chronic.parse event.end
    calendar_event.follow_up_boss_id = event.id
    calendar_event.save
    calendar_event
  end
  
  def CalendarEvent.find_or_create_from_follow_up_boss event
    create_from_follow_up_boss event unless where(:follow_up_boss_id => event['id']).present?
  end
  
  def to_follow_up_boss
    appointment = FubClient::Appointment.new
    appointment.title = title
    appointment.description = description
    appointment.location = location
    appointment.start = start_time.utc
    appointment.end = end_time.utc
    appointment.invitees = invitees
    # suppress invitation email  /api/v1/appointments?sendInvitation=false      doesn't seem necessary
    # it's not necessary now, but might be some day
    begin
      appointment.save
    rescue NoMethodError => exception
      Rails.logger.debug exception.inspect
    end
    update_attribute :follow_up_boss_id, appointment.id
  end
  
  def push_to_follow_up_boss fub_calendar_event = nil
    unless fub_calendar_event
      fub_calendar_event = FubCalendarEvent.new
      fub_calendar_event.agent = agent
      fub_calendar_event.load_cookie
      fub_calendar_event.access_calendar_page
    end
    fub_calendar_event.access_event_input_form
    fub_calendar_event.add_event self, invitees.map { |invitee| invitee['name'] }
  end
  
  def CalendarEvent.google_calendar agent
    Google::Calendar.new({:calendar => agent.google_calendar_id}, google_connection(agent.google_tokens))
  end
  
  def CalendarEvent.google_connection tokens
    Google::Connection.factory(
      :client_id => Rails.application.credentials.google[:client_id],
      :client_secret => Rails.application.credentials.google[:client_secret],
      :refresh_token => tokens['refresh_token'],
      :access_token => tokens['access_token'],
      :redirect_url  => url_helpers.token_calendar_events_url
    )
  end
  
  def microsoft_calendar
    microsoft_connection.get_events Agent.find(31).cookies.last.download
  end
  
  def microsoft_connection
    RubyOutlook::Client.new
  end
end
