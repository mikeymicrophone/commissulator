module ApplicationHelper
  def link_to_name obj, attribute = nil
    return '' unless obj
    if attribute
      link_to obj.send(attribute), obj
    else
      link_to obj.name, obj
    end
  end
  
  def google_fonts
    google_webfonts_init :google => selected_fonts
  end
  
  def selected_fonts
    ['Bitter', 'Arvo', 'Cinzel']
  end
end
