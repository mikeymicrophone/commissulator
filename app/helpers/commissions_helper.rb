module CommissionsHelper
  def tenant_info_row
    content_tag :div, :class => 'commission_form_row' do
      label_tag(:commission_tenant_name, 'Tenant name') + ' ' +
      text_field_tag(:'commission[tenant_name][]') + ' ' +
      label_tag(:commission_tenant_email, 'Tenant email') + ' ' +
      text_field_tag(:'commission[tenant_email][]') + ' ' +
      label_tag(:commission_tenant_phone_number, 'Tenant phone number') + ' ' +
      text_field_tag(:'commission[tenant_phone_number][]')
    end
  end
  
  def commission_row_for commission
    columns = [
      content_tag(:td, commission.property_address),
      content_tag(:td, link_to_name(commission.deal, :unit_number)),
      content_tag(:td, commission.tenant_name.join(', ')),
      content_tag(:td, number_to_currency(commission.leased_monthly_rent)),
      content_tag(:td, link_to(number_to_currency(commission.total_commission), commission)),
      content_tag(:td, link_to_name(commission.landlord)),
      content_tag(:td, commission.zip_code),
      content_tag(:td, commission.updated_at.to_s(:descriptive)),
      content_tag(:td, link_to(fa_icon(:stream, :size => '2x'), commission, :title => 'Review Commission Data')),
      content_tag(:td, link_to(fa_icon(:file_invoice_dollar, :size => '2x'), commission.deal, :title => 'Finance Breakdown')),
      content_tag(:td, link_to(fa_icon(:newspaper, :size => '2x'), edit_commission_path(commission), :title => 'Update Paperwork')),
      content_tag(:td, link_to(fa_icon(:file_export, :size => '2x'), commission_path(commission, :format => :pdf), :title => 'Print Preview of Rental Request for Commission')),
      content_tag(:td, commission.documents.present? ? link_to(fa_icon(:hdd, :text => "(#{commission.documents.count})", :size => '2x'), documents_path(:filtered_attribute => :deal_id, :filter_value => commission.deal), :title => pluralize(commission.documents.count, 'Uploaded Document')) : '', :class => 'document_list'),
      content_tag(:td, link_to(fa_icon(:file_signature, :size => '2x'), new_document_path(:document => {:deal_id => commission.deal}), :title => 'Attach Document')),
      content_tag(:td, commission.documented? ? link_to(fa_icon(:paper_plane, :size => '2x'), submit_commission_path(commission), :method => :put, :remote => true, :id => dom_id(commission, :submission_link_for), :title => 'Submit to Senior Agent via Email') : ''),
      content_tag(:td, link_to(fa_icon(:joint, :size => '2x'), commission, :method => :delete, :remote => true, :title => 'Delete Commission Entry', :data => {:confirm => 'Are you sure?'}), :class => 'commission_removal')
    ]
    
    if commission.follow_up == 'unsubmitted'
      columns << content_tag(:td, link_to(fa_icon(:people_carry, :size => '2x'), follow_up_commission_path(commission), :method => :put, :remote => true, :id => dom_id(commission, :follow_up_for)), :class => 'follow_up', :title => 'Sync Tenants to Follow Up Boss')
    end
    
    content_tag_for :tr, commission do
      columns.join.html_safe
    end
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
    if number == BigDecimal(0)
      ''
    elsif cents == '00' || cents == '.0'
      number.round
    else
      number.round 2
    end
  end
  
  def number_to_round_currency number
    number_to_currency number, :precision => (number.round == number) ? 0 : 2 if number > 0
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
      content_tag(:a, 'dated', :title => commission.dated_title, :class => "commission_status #{commission.dated? ? 'satisfied' : 'unsatisfied'}")
    end
  end
end
