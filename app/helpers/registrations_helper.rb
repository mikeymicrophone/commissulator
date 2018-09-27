module RegistrationsHelper
  def price_range_options
    options_for_select Registration::PRICES
  end
  
  def size_options
    options_for_select Registration::APARTMENT_SIZES
  end
  
  def fabricate_registration_link
    link_to 'Fabricate Registration', fabricate_registrations_path, :method => :post unless Rails.env.production?
  end
  
  def begin_registration_tool
    content_tag :div, :id => 'begin_registration_tool' do
      begin_registration_link +
      registration_agent_picker
    end
  end
  
  def begin_registration_link
    link_to fa_icon(:arrow_circle_right, :text => 'Begin Registration'), begin_registration_path
  end
  
  def registration_agent_picker
    content_tag :div, :id => 'registration_agent_picker' do
      Agent.active.alpha.map do |agent|
        link_to begin_registration_path(:agent_id => agent.id) do
          div_for agent do
            agent.name
          end
        end
      end.join.html_safe
    end
  end
end
