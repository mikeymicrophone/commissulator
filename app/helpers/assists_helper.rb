module AssistsHelper
  def linked_name assist, delete_link = true
    "#{link_to assist.role, assist} by #{link_to_name assist.assistant} #{delete_link ? link_to('x', assist, :method => :delete, :remote => true) : ''}".html_safe
  end
  
  def participation_in role
    link_to role, assists_path(:filtered_attribute => :role, :filter_value => role)
  end
end
