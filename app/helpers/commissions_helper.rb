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
end
