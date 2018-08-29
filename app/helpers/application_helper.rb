module ApplicationHelper
  def link_to_name obj, attribute = nil
    return '' unless obj
    if attribute
      link_to obj.send(attribute), obj
    else
      link_to obj.name, obj
    end
  end
  
  def main_nav
    link_to('New Commission', new_commission_path, :id => 'new_commission_link') +
    link_to(fa_icon(:chart_pie, :text => 'Commissions'), commissions_path, :id => 'commissions_link') +
    # link_to(fa_icon(:clipboard_list, :text => 'Documents'), documents_path) +
    # link_to(fa_icon(:balance_scale, :text => 'Deals'), deals_path) +
    # link_to(fa_icon(:basketball_ball, :text => 'Assists', :animation => 'spin'), assists_path) +
    # link_to(fa_icon(:user_tie, :text => 'Agents'), agents_path) +
    link_to(fa_icon(:warehouse, :text => 'Landlords'), landlords_path) +
    if current_agent.admin?
      link_to(fa_icon(:users, :text => 'Assistants'), assistants_path)
    end
  end
  
  def penthouse_nav
    content_tag :nav, :id => 'top_floor_penthouse_navigation' do
      if current_agent
        main_nav +
        link_to('Sign Out', destroy_agent_session_path, :method => :delete, :id => 'sign_out_link') +
        link_to('Me', edit_agent_path(current_agent), :id => 'profile_link')
      else
        link_to('Log In', new_agent_session_path) +
        link_to('Register', new_agent_registration_path)
      end
    end
  end
  
  def filter_params record = nil
    record ? {:filtered_attribute => record.foreign_key_name, :filter_value => record.id} : {:filtered_attribute => params[:filtered_attribute], :filter_value => params[:filter_value]}
  end
  
  def clearboth
    tag.div :class => 'clearboth'
  end
  
  def google_fonts
    google_webfonts_init :google => selected_fonts
  end
  
  def selected_fonts
    ['Arvo', 'Bitter', 'Cinzel', 'Fjalla One', 'Jua', 'M PLUS Rounded 1c', 'Nunito']
  end
end
