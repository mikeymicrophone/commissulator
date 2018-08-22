module CommissionsHelper
  def tenant_info_row
    content_tag :div, :class => 'commission_form_row' do
      label_tag(:commission_tenant_name, 'Tenant name') +
      text_field_tag(:'commission[tenant_name][]') +
      label_tag(:commission_tenant_email, 'Tenant email') +
      text_field_tag(:'commission[tenant_email][]') +
      label_tag(:commission_tenant_phone_number, 'Tenant phone number') +
      text_field_tag(:'commission[tenant_phone_number][]')
    end
  end
  
  def commission_row_for commission
    columns = [
      content_tag(:td, commission.tenant_name.join(', ')),
      content_tag(:td, number_to_currency(commission.leased_monthly_rent)),
      content_tag(:td, link_to_name(commission.deal, :unit_number)),
      content_tag(:td, link_to_name(commission.landlord)),
      content_tag(:td, commission.zip_code),
      content_tag(:td, completion_state(commission)),
      content_tag(:td, commission.updated_at.to_s(:descriptive)),
      content_tag(:td, link_to('Show', commission)),
      content_tag(:td, link_to('Edit', edit_commission_path(commission))),
      content_tag(:td, link_to('Print', commission_path(commission, :format => :pdf)))
    ]
    
    content_tag :tr, columns.join.html_safe
  end
  
  def fabricate_commission_link fabricator, opts = {}
    link_to %Q{Fabricate #{fabricator}}, fabricate_commissions_path(opts.merge :fabricator => fabricator), :method => :post, :remote => true unless Rails.env.production?
  end
  
  def pad information, width = 15
    length = information.to_s.length
    padding = width - length / 2
    padding > 0 ? "#{Prawn::Text::NBSP * padding}#{information}#{Prawn::Text::NBSP * padding}" : information
  end
  
  def rounded number
    number = number.to_d
    cents = number.round(2).to_s[-2..-1]
    if cents == '00' || cents == '.0'
      number.round
    else
      number.round 2
    end
  end
  
  def number_to_round_currency number
    number_to_currency number, :precision => (number.round == number) ? 0 : 2 if number
  end
  
  def broker_box attribute, pdf, spot, opts
    pdf.bounding_box spot, :width => 10, :height => 10 do
      pdf.draw_text 'X', :at => [1, 1], :size => 12 if attribute
      pdf.stroke_bounds
    end
  end
  
  def completion_state commission
    content_tag :div, :id =>"commission_data_status" do
      content_tag(:a, 'located', :title => commission.located_title, :class => "commission_status #{commission.located? ? 'satisfied' : 'unsatisfied'}") +
      content_tag(:a, 'populated', :title => commission.populated_title, :class => "commission_status #{commission.populated? ? 'satisfied' : 'unsatisfied'}") +
      content_tag(:a, 'known', :title => commission.known_title, :class => "commission_status #{commission.known? ? 'satisfied' : 'unsatisfied'}") +
      content_tag(:a, 'owned', :title => commission.owned_title, :class => "commission_status #{commission.owned? ? 'satisfied' : 'unsatisfied'}") +
      content_tag(:a, 'dealt', :title => commission.dealt_title, :class => "commission_status #{commission.dealt? ? 'satisfied' : 'unsatisfied'}") +
      content_tag(:a, 'brokered', :title => commission.brokered_title, :class => "commission_status #{commission.brokered? ? 'satisfied' : 'unsatisfied'}") +
      content_tag(:a, 'referred', :title => commission.referred_title, :class => "commission_status #{commission.referred? ? 'satisfied' : 'unsatisfied'} optional") +
      content_tag(:a, 'cut', :title => commission.cut_title, :class => "commission_status #{commission.cut? ? 'satisfied' : 'unsatisfied'}") +
      content_tag(:a, 'detailed', :title => commission.detailed_title, :class => "commission_status #{commission.detailed? ? 'satisfied' : 'unsatisfied'}")
    end
  end
end
