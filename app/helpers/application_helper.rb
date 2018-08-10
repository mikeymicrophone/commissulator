module ApplicationHelper
  def link_to_name obj
    return '' unless obj
    link_to obj.name, obj
  end
end
