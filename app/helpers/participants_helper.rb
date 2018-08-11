module ParticipantsHelper
  def linked_name participant
    "#{link_to participant.role, participant} by #{link_to_name participant.assistant}".html_safe
  end
end
