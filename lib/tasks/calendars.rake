namespace :calendars do
  desc 'find newly created events and add them to the corresponding Follow Up Boss calendar'
  task :google_to_fub => :environment do
    calendar_driver = FubCalendarEvent.new
    Agent.where.not(:google_calendar_id => nil).find_each do |agent|
      if agent.google_calendar_id.present?
        calendar_driver.agent = agent
        local_events = []
        agent.google_calendar.events.each do |event|
          if CalendarEvent.where(:google_id => event.id).present?
            puts "We already have the event #{event.title}."
          else
            local_events << CalendarEvent.create_from_google(event, agent)
          end
        end
        if local_events.present?
          calendar_driver.load_cookie
          calendar_driver.access_calendar_page
          
          local_events.each &:to_follow_up_boss
        end
      end
    end
  end
  
  desc 'find newly created events and add them to the corresponding Google calendar'
  task :fub_to_google => :environment do
    Agent.where.not(:google_calendar_id => nil).find_each do |agent|
      latest_event_id = CalendarEvent.order('id desc').first.id
      agent.ingest_fub_appointments
      agent.calendar_events.where(CalendarEvent.arel_table[:id].gt latest_event_id).each &:push_to_google
    end
  end
  
  desc 'scrape newly created events and add them to the corresponding Google calendar'
  task :fub_scrape_to_google => :environment do
    calendar_driver = FubCalendarEvent.new
    Agent.where.not(:google_calendar_id => nil).find_each do |agent|
      calendar_driver.agent = agent
      calendar_driver.load_cookie
      calendar_driver.access_calendar_page
      local_events = []
      
      calendar_driver.events.each do |event|
        code = calendar_driver.event_code event
        if CalendarEvent.where(:follow_up_boss_id => code).present?
          puts "We already have the event #{code}."
        else
          local_events << calendar_driver.scrape_event(event)
        end
      end
      
      calendar_driver.more_events_links&.each do |expander|
        expander.click
        calendar_driver.expanded_day_area.divs(:class => 'MonthAppointment')[3..-1].each do |event|
          code = calendar_driver.expanded_event_code event
          day_number = calendar_driver.expanded_event_date event
          if CalendarEvent.where(:follow_up_boss_id => code).present?
            puts "We already have the event #{code}."
          else
            local_events << calendar_driver.scrape_event(event)
            calendar_driver.browser.div(:class => 'MonthDay-date', :text => day_number).click
          end
        end
      end
      
      local_events.compact!
      local_events.each do |event|
        event.retrieve_invitee_emails
        event.agent_is_invitee
      end
      
      local_events.each &:push_to_google
    end
  end
end
