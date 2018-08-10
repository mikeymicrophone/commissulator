module ApplicationHelper
  def link_to_name obj
    return '' unless obj
    link_to obj.name, obj
  end
  
  def google_fonts
    google_webfonts_init :google => selected_fonts
  end
  
  def selected_fonts
    ['Bitter', 'Arvo', 'Cinzel']
  end
end
