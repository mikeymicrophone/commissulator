module ApplicationHelper
  def link_to_name object, attribute = :name, arguments = nil
    link_to object.send(attribute, *arguments), object if object
  end
  
  def link_to_name_with_icon object, arguments = nil
    link_to_name object, :anchor, arguments
  end
  
  def icon_for_class object
    case object
    when Client
      :address_card
    end
  end
  
  def avatar_nav
    content_tag :nav, :id => 'registration_navigation' do
      if current_avatar
        registration_access_nav +
        if current_avatar.admin?
          tag.br +
          registration_data_nav +
          tag.br +
          registration_join_nav
        end
      end
    end
  end
  
  def registration_access_nav
    [
      begin_registration_agent_link,
      resource_path(Client),
      resource_path(Registration),
      resource_path(Employer),
      resource_path(Industry),
      resource_path(ReferralSource, :class => 'hiding')
    ].join(' ').html_safe
  end
  
  def registration_data_nav
    [
      resource_path(Apartment, :class => :secondary),
      resource_path(Lease, :class => :secondary),
      resource_path(Phone, :class => :secondary),
      resource_path(Email, :class => :secondary),
      resource_path(SocialAccount, :class => :secondary)
    ].join(' ').html_safe
  end
  
  def registration_join_nav
    [
      resource_path(Registrant, :class => :join),
      resource_path(Tenant, :class => :join),
      resource_path(Employment, :class => :join),
      resource_path(Niche, :class => :join),
      resource_path(Package, :class => :join),
      resource_path(Role, :class => :join),
      resource_path(Involvement, :class => :join)
    ].join(' ').html_safe
  end
  
  def resource_path resource, options = {}
    anchor = ApplicationController.helpers.fa_icon resource.new.icon, :text => resource.name.pluralize
    link_to anchor, send("#{resource.name.underscore.pluralize}_path"), options
  end
  
  def link_to_associated object, resource
    anchor = ApplicationController.helpers.fa_icon resource.to_s.classify.constantize.new.icon, :text => pluralize(object.send(resource).count, resource.to_s.singularize)
    link_to anchor, send("#{resource}_path", filter_params(object)) if object.send(resource).present?
  end
  
  def main_nav
    link_to('New Commission', new_commission_path, :id => 'new_commission_link') +
    link_to(fa_icon(:chart_pie, :text => 'Commissions'), commissions_path, :id => 'commissions_link') +
    link_to(fa_icon(:clipboard_list, :text => 'Documents'), documents_path, :class => 'hiding') +
    # link_to(fa_icon(:balance_scale, :text => 'Deals'), deals_path) +
    link_to(fa_icon(:basketball_ball, :text => 'Assists', :animation => 'spin'), assists_path, :class => 'hiding') +
    link_to(fa_icon(:user_tie, :text => 'Avatars'), avatars_path, :class => 'hiding') +
    link_to(fa_icon(:warehouse, :text => 'Landlords'), landlords_path) +
    if current_avatar.admin?
      link_to(fa_icon(:users, :text => 'Agents'), agents_path)
    end
  end
  
  def penthouse_nav
    content_tag :nav, :id => 'top_floor_penthouse_navigation' do
      link_to('Home', root_url) +
      if current_avatar
        main_nav +
        link_to('Sign Out', destroy_avatar_session_path, :method => :delete, :id => 'sign_out_link') +
        link_to('Me', edit_avatar_path(current_avatar), :id => 'profile_link') +
        if current_avatar.admin?
          link_to('Toggle', toggle_navigation_path, :id => 'nav_toggler', :remote => true)
        end
      else
        link_to('Log In', new_avatar_session_path) +
        link_to('Request an Account', new_avatar_registration_path)
      end
    end
  end
  
  def filter_params record = nil
    record ? {:filtered_attribute => record.foreign_key_name, :filter_value => record.id} : {:filtered_attribute => params[:filtered_attribute], :filter_value => params[:filter_value]}
  end
  
  def markdown
    @renderer ||= Redcarpet::Render::HTML.new
    @markdown ||= Redcarpet::Markdown.new @renderer
  end
  
  def mark_up content
    markdown.render(content.to_s).html_safe
  end
  
  def title
    @title || 'Citi Pads'
  end
  
  def clearboth
    tag.div :class => 'clearboth'
  end
  
  def google_fonts
    google_webfonts_init :google => selected_fonts
  end
  
  def selected_fonts
    ['Alegreya', 'Arvo', 'Bitter', 'Cinzel', 'Cormorant Infant', 'Fjalla One', 'Joana Correia', 'Jua', 'M PLUS Rounded 1c', 'Nunito', 'Quattrocento']
  end

  def generate_edit_link_for object
    if can? :edit, object
			link_to fa_icon(:highlighter), send("edit_#{object.class.to_s.underscore}_path", object), :title => 'Edit'
		end
	end

	def delete_employer_link object
		if can? :delete, object
			link_to fa_icon(:backspace), send("#{object.class.to_s.underscore}_path", object), method: :delete, data: { confirm: 'Are you sure?' }, :title => 'Delete'
		end
  end
end
