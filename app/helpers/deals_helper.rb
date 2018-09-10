module DealsHelper
  def assist_adder deal
    form_with :model => deal.assists.new, :id => 'assist_adder' do |form|
      form.select(:role, Assist.roles.keys) +
      form.select(:agent_id, options_from_collection_for_select(Agent.recent.active, :id, :name) + (add_name_option)) +
      form.submit(:add) +
      form.hidden_field(:deal_id)
    end
  end
  
  def add_name_option
    content_tag :option, 'Add Name', :id => 'add_name_option', :value => 'Add Name'
  end
  
  def status_clicker_for deal
    div_for deal, :status_clicker_for do
      link_to deal.status, pick_status_of_deal_path(deal), :remote => true
    end
  end
  
  def status_picker_for deal
    div_for deal, :status_picker_for do
      select_tag :status, options_for_select(Deal.statuses.keys, deal.status)
    end
  end
  
  def deal_row_for deal
    columns = [
      content_tag(:td, link_to_name_with_icon(deal, :reference)),
      content_tag(:td, number_to_currency(deal.commission&.total_commission)),
      content_tag(:td, link_to_name_with_icon(deal.agent)),
      content_tag(:td, deal.address),
      content_tag(:td, deal.unit_number),
      content_tag(:td, status_clicker_for(deal)),
      content_tag(:td, deal.updated_at&.to_s(:descriptive)),
      content_tag(:td, link_to(fa_icon(:file_invoice_dollar, :size => '2x'), deal, :title => 'Finance Breakdown')),
      content_tag(:td, link_to(fa_icon(:atlas, :size => '2x'), edit_deal_path(deal), :title => 'Manage Deal Details')),
      content_tag(:td, link_to(fa_icon(:file_signature, :size => '2x'), new_document_path(:document => {:deal_id => deal}), :title => 'Attach Document'))
    ]
    
    if deal.commission
      columns << content_tag(:td, link_to(fa_icon(:newspaper, :size => '2x'), edit_commission_path(deal.commission), :title => 'Update Paperwork'))
      columns << content_tag(:td, link_to(fa_icon(:file_export, :size => '2x'), commission_path(deal.commission, :format => :pdf), :title => 'Print Preview of Rental Request for Commission'))
    else
      columns << content_tag(:td, link_to(fa_icon(:newspaper, :size => '2x'), new_commission_path(:deal_id => deal.id), :title => 'Begin Paperwork'))
      columns << tag.td
    end
    
    if deal.documents.present?
      columns << content_tag(:td, link_to(fa_icon(:hdd, :text => "(#{deal.documents.count})", :size => '2x'), documents_path(filter_params deal), :title => pluralize(deal.documents.count, 'Uploaded Document')), :class => 'document_list')
    else
      columns << content_tag(:td, link_to(fa_icon(:hdd, :size => '2x'), documents_path, :title => pluralize(deal.documents.count, 'Uploaded Document')), :class => 'document_list')
    end
    
    if current_avatar.admin?
      columns << content_tag(:td, link_to(fa_icon(:backspace, :class => 'deletion', :size => '2x'), deal, :title => 'Delete Deal and its Assists', :method => :delete, :remote => true, :data => {:confirm => 'Are you sure?'}), :class => 'deal_removal')
    end
    
    content_tag :tr, columns.join.html_safe, :id => dom_id(deal)
  end
  
  def fabricate_deal_link opts = {}
    if params[:filtered_attribute] == 'agent_id'
      opts[:agent_id] = params[:filter_value]
    end
    link_to "Fabricate #{opts[:status]} deal", fabricate_deals_path(:deal => opts), :method => :post, :remote => true unless Rails.env.production?
  end
  
  def special_payments_on deal
    deal.special_payments.join
  end
end
