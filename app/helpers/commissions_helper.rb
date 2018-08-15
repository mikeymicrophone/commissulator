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
      content_tag(:td, commission.updated_at.to_s(:descriptive)),
      content_tag(:td, link_to('Show', commission)),
      content_tag(:td, link_to('Edit', edit_commission_path(commission))),
      content_tag(:td, link_to('Print', commission_path(commission, :format => :pdf)))
    ]
    
    content_tag :tr, columns.join.html_safe
  end
  
  def fabricate_commission_link opts = {}
    link_to 'Fabricate', fabricate_commissions_path(opts), :method => :post, :remote => true
  end
  
  def pad information, width = 15
    length = information.to_s.length
    padding = width - length / 2
    "#{Prawn::Text::NBSP * padding}#{information}#{Prawn::Text::NBSP * padding}"
  end
  
  def broker_box attribute, pdf, spot, opts
    pdf.bounding_box spot, :width => 10, :height => 10 do
      pdf.draw_text 'X', :at => [1, 1], :size => 12 if attribute
      pdf.stroke_bounds
    end
  end
end
