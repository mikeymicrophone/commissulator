module ParticipantsHelper
  def linked_name participant
    "#{participant.role} by #{link_to_name participant.assistant}".html_safe
  end
end
