module AssistsHelper
  def linked_name assist
    admin_tools = [
      link_to(fa_icon(:highlighter), edit_assist_path(assist), :title => 'Adjust'),
      link_to(fa_icon(:backspace), assist, :method => :delete, :remote => true, :title => 'Delete')
    ]
    icon = case assist.role
    when 'lead'
      :hand_paper #:list
    when 'interview'
      :handshake
    when 'show'
      :hands_helping #:key
    when 'close'
      :hand_holding_usd #:paste
    end
    "#{link_to fa_icon(icon, :text => assist.role.capitalize), assist} by #{link_to_name assist.assistant}. #{admin_tools.join if current_agent.admin?}".html_safe
  end
  
  def participation_in role
    link_to role, assists_path(:filtered_attribute => :role, :filter_value => role)
  end
end
