module RegistrationsHelper
  def price_range_options
    prices = Registration.rent_budget_prices
    prices.map! { |price| [price.to_i.to_s, price.to_i] }
    max_level = prices.last
    max_level = [max_level.first + '+', max_level.last]
    prices[-1] = max_level
    options_for_select prices
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
    link_to fa_icon(:arrow_circle_right, :text => 'Begin Registration'), '#'
  end
  
  def begin_registration_agent_link
    link_to fa_icon(:arrow_circle_right, :text => 'Begin Registration'), begin_registration_path(:agent_id => current_avatar.agent&.id)
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
  
  def client_box bind, top_corner, client_number
    bind.bounding_box top_corner, :width => 250, :height => 205 do
      bind.font 'Oswald', :size => 16 do
        bind.draw_text "CLIENT #{client_number}", :font => 'Oswald', :at => [0, 190]
      end
      bind.draw_text 'Name:', :at => [0, 170]
      bind.line [30, 168], [245, 168]
    
      bind.draw_text 'Address:', :at => [0, 154]
      bind.line [40, 152], [190, 152]
      
      bind.draw_text 'Apt:', :at => [195, 154]
      bind.line [215, 152], [245, 152]
      
      bind.draw_text 'City:', :at => [0, 138]
      bind.line [25, 136], [115, 136]
      
      bind.draw_text 'State:', :at => [120, 138]
      bind.line [145, 136], [175, 136]
      
      bind.draw_text 'ZIP:', :at => [180, 138]
      bind.line [200, 136], [245, 136]
      
      bind.draw_text 'Telephone (home):', :at => [0, 122]
      bind.line [80, 120], [245, 120]
      
      bind.draw_text 'Telephone (cell):', :at => [0, 106]
      bind.line [76, 104], [245, 104]
      
      bind.draw_text 'Telephone (work):', :at => [0, 90]
      bind.line [80, 88], [245, 88]
      
      bind.draw_text 'Email:', :at => [0, 74]
      bind.line [30, 72], [245, 72]
      
      bind.draw_text 'Employer:', :at => [0, 58]
      bind.line [45, 56], [245, 56]
      
      bind.draw_text 'Address:', :at => [0, 42]
      bind.line [38, 40], [245, 40]
      
      bind.draw_text 'Position:', :at => [0, 26]
      bind.line [38, 24], [245, 24]
      
      bind.draw_text 'Current Landlord:', :at => [0, 10]
      bind.line [75, 8], [245, 8]
    
      bind.stroke
    end
  end
end
