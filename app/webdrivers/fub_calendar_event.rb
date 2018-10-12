class FubCalendarEvent < FubAuthenticated
  def access_calendar_page
    browser.goto calendar_domain
  end
  
  def advance_to_next_month
    
  end
  
  def events
    browser.divs :class => 'MonthAppointment'
  end
  
  def event_name event
    event_text = /[\d\w\,]+\s\-\s([\w\s]+)/
    matches = event_text.match event.text
    matches[1]
  end
  
  def event_date event
    event.parent.parent.div(:class => 'MonthDay-date').text
  end
  
  def month
    browser.div(:class => 'FUBCalendar-menu').h4.text
  end
  
  def event_code event
    "#{month} #{event_date} #{event_name}"
  end
  
  def access_event_edit_form event
    event.click
    popover = browser.div :class => 'MonthAppointment-popover'
    popover.link(:text => 'Edit Appointment').click
  end
  
  def close_event_edit_form
    # escape key would probably work
  end
  
  def access_event_input_form
    event_adder = browser.div :class => 'FUBCalendar-addEvent'
    event_adder.button(:class => 'u-button').click
  end
  
  def add_event calendar_event, guests
    title_field.set calendar_event.title
    description_field.set calendar_event.description
    date_field.set calendar_event.start_time.strftime '%m/%d/%Y'
    time_field.set calendar_event.start_time.strftime '%I:%M %p'
    end_date_field.set calendar_event.end_time.strftime '%m/%d/%Y'
    end_time_field.set calendar_event.end_time.strftime '%I:%M %p'
    location_field.set calendar_event.location
    guests.each { |guest| add_guest guest }
    submit_form
  end
  
  def scrape_event event
    access_event_edit_form event
    calendar_event = CalendarEvent.new
    calendar_event.title = title_field.value
    calendar_event.description = description_field.value
    calendar_event.location = location_field.value
    calendar_event.start_time = Chronic.parse date_field.value + ' ' + time_field.value
    calendar_event.end_time = Chronic.parse end_date_field.value + ' ' + end_time_field.value
    calendar_event.invitees = guest_list
    calendar_event.follow_up_boss_id = event_code event
    calendar_event.save
  end
  
  def guest_list
    invitees = browser.lis :class => 'AppointmentModal-InviteeChip'
    invitees.map do |invitee|
      invitee.div(:class => 'Avatar').title
    end
  end
  
  def add_guest name
    invitee_picker = invitee_group_area.text_field :placeholder => 'Add Invitee'
    invitee_picker.set name
    browser.send_keys :enter
  end
  
  def submit_form
    browser.div(:class => 'Modal-footer').button(:text => 'Create Appointment').click # the class 'u-bigBlueButton' would hit the edit/save button as well as the create/submit one; however I may not need to edit events, just using the edit form to scrape them
  end
  
  def invitee_group_area
    appointment_form.div :class => 'AppointmentModal-Invitees'
  end
  
  def location_field
    if appointment_form.div(:class => 'AppointmentModal-Location').exists?
      appointment_form.div(:class => 'AppointmentModal-Location').text_field
    else
      appointment_form.div(:class => 'AppointmentModal-Location-withLink').text_field
    end
  end
  
  def end_time_field
    date_parameters.div(:class => 'AppointmentModal-endTime').text_field
  end
  
  def time_field
    date_parameters.div(:class => 'AppointmentModal-startTime').text_field
  end
  
  def end_date_field
    date_parameters.divs(:class => 'AppointmentModal-DatePicker').last.text_field(:class => 'form-control')
  end
  
  def date_field
    date_parameters.div(:class => 'AppointmentModal-DatePicker').text_field(:class => 'form-control')
  end
  
  def date_parameters
    appointment_form.div :class => 'AppointmentModal-DateTime'
  end
  
  def description_field
    appointment_form.textarea :class => 'AppointmentModal-textArea'
  end
  
  def title_field
    appointment_form.text_field :class => 'AppointmentModal-Input'
  end
  
  def appointment_form
    browser.form :class => 'AppointmentModal-form'
  end
  
  def calendar_domain
    if Rails.env.production?
      "#{Rails.application.credentials.follow_up_boss[:subdomain]}.followupboss.com/2/calendar"
    else
      "#{Rails.application.credentials.follow_up_boss[:staging_subdomain]}.followupboss.com/2/calendar"
    end
  end
end
