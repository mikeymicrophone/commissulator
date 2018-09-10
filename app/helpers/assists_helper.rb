module AssistsHelper
  def linked_name assist
    admin_tools = [
      link_to(fa_icon(:highlighter), edit_assist_path(assist), :title => 'Adjust'),
      link_to(fa_icon(:backspace), assist, :method => :delete, :remote => true, :title => 'Delete')
    ]
    icon = 
    "#{link_to icon_for(assist.role), assist} by #{link_to_name_with_icon assist.agent}. #{admin_tools.join if current_avatar.admin?}".html_safe
  end
  
  def icon_for role
    icon = case role
    when 'lead'
      :hand_paper #:list
    when 'interview'
      :handshake
    when 'show'
      :hands_helping #:key
    when 'close'
      :hand_holding_usd #:paste
    when 'custom'
      :bolt
    end
    fa_icon(icon, :text => role.capitalize)
  end
  
  def participation_in role
    link_to icon_for(role), assists_path(:filtered_attribute => :role, :filter_value => role)
  end
end
