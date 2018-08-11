module ParticipantsHelper
  def linked_name participant
    "#{link_to participant.role, participant} by #{link_to_name participant.assistant}".html_safe
  end
  
  def participation_in role
    link_to role, participants_path(:filtered_attribute => :role, :filter_value => role)
  end
end
