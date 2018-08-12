module CommissionsHelper
  def tenant_info_row
    content_tag :div, :class => 'commission_form_row' do
      label_tag(:commission_tenant_name, 'Tenant name') +
      text_field_tag(:'commission[tenant_name][]') +
      label_tag(:commission_tenant_email, 'Tenant email') +
      text_field_tag(:'commission[tenant_email][]') +
      label_tag(:commission_tenant_phone_number, 'Tenant phone number') +
      text_field_tag(:'commission[tenant_phone_number][]') +
      link_to('x', '#', :class => 'row_remover')
    end
  end
  
  def commission_row_for commission
    columns = [
      content_tag(:td, commission.tenant_name.join(', ')),
      content_tag(:td, number_to_currency(commission.leased_monthly_rent)),
      content_tag(:td, commission.apartment_number),
      content_tag(:td, commission.landlord_name),
      content_tag(:td, commission.zip_code),
      content_tag(:td, commission.updated_at.to_s(:descriptive)),
      content_tag(:td, link_to('Show', commission)),
      content_tag(:td, link_to('Edit', edit_commission_path(commission)))
    ]
    
    content_tag :tr, columns.join.html_safe
  end
  
  def fabricate_commission_link opts = {}
    link_to 'Fabricate', fabricate_commissions_path(:commission => opts), :method => :post, :remote => true
  end
end
