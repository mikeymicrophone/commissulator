module ParticipantsHelper
  def linked_name participant, delete_link = true
    "#{link_to participant.role, participant} by #{link_to_name participant.assistant} #{delete_link ? link_to('x', participant, :method => :delete, :remote => true) : ''}".html_safe
  end
  
  def participation_in role
    link_to role, participants_path(:filtered_attribute => :role, :filter_value => role)
  end
end
