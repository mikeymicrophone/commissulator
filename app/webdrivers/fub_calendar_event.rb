class FubCalendarEvent < FubAuthenticated
  def access_calendar_page
    browser.goto calendar_domain
  end
  
  def events
    browser.divs :class => 'MonthAppointment'
  end
  
  def access_event_edit_form event
    event.click
    popover = browser.div :class => 'MonthAppointment-popover'
    popover.link(:text => 'Edit Appointment').click
  end
  
  def access_event_input_form
    event_adder = browser.div :class => 'FUBCalendar-addEvent'
    event_adder.button(:class => 'u-button').click
  end
  
  def add_event appointment_name, description, appointment_time, duration, guests # guests should respond to #name
    title_field.set appointment_name
    description_field.set description
    date_field.set appointment_time.strftime '%m/%d/%Y'
    time_field.set appointment_time.strftime '%I:%M %p'
    # default time is 1 hour, no duration implemented yet
    guests.each { |guest| add_guest guest.name }
    submit_form
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
  
  def time_field
    date_parameters.div(:class => 'AppointmentModal-startTime').text_field
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
