namespace :calendars do
  desc 'find newly created events and add them to the corresponding Follow Up Boss calendar'
  task :google_to_fub => :environment do
    calendar_driver = FubCalendarEvent.new
    Agent.where.not(:google_calendar_id => nil).find_each do |agent|
      if agent.google_calendar_id.present?
        calendar_driver.agent = agent
        local_events = []
        google_calendar = CalendarEvent.google_calendar agent
        google_calendar.events.each do |event|
          if CalendarEvent.where(:google_id => event.id).present?
            puts "We already have the event #{event.title}."
          else
            local_event = CalendarEvent.create_from_google(event, agent)
            local_event.agent = agent
            local_event.save
            local_events << local_event
          end
        end
        if local_events.present?
          # I wonder if I can just go from cookie to cookie without logging out
          calendar_driver.load_cookie
          calendar_driver.access_calendar_page
          
          local_events.each &:push_to_follow_up_boss
        end
      end
    end
  end
  
  desc 'find newly created events and add them to the corresponding Google calendar'
  task :fub_to_google => :environment do
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
      
      calendar_driver.more_events_links.each do |expander|
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
      
      local_events.each do |event|
        event.retrieve_invitee_emails
        event.agent_is_invitee
      end
      
      local_events.each &:push_to_google
    end
  end
end
