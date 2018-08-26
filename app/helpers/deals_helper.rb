module DealsHelper
  def assist_adder deal
    form_with :model => deal.assists.new, :id => 'assist_adder' do |form|
      form.select(:role, Assist.roles.keys) +
      form.select(:assistant_id, options_from_collection_for_select(Assistant.recent.active, :id, :name) + (add_name_option)) +
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
      content_tag(:td, link_to_name(deal, :reference)),
      content_tag(:td, number_to_currency(deal.commission&.total_commission)),
      content_tag(:td, deals_by(deal.agent)),
      content_tag(:td, deal.address),
      content_tag(:td, deal.unit_number),
      content_tag(:td, status_clicker_for(deal)),
      content_tag(:td, deal.updated_at&.to_s(:descriptive)),
      content_tag(:td, link_to(fa_icon(:file_invoice_dollar), deal, :title => 'Finance Breakdown')),
      content_tag(:td, link_to(fa_icon(:atlas), edit_deal_path(deal), :title => 'Manage Deal Details')),
      content_tag(:td, link_to(fa_icon(:file_signature), new_document_path(:document => {:deal_id => deal}), :title => 'Attach Document'))
    ]
    
    if deal.commission
      columns << content_tag(:td, link_to(fa_icon(:newspaper), edit_commission_path(deal.commission), :title => 'Update Paperwork'))
      columns << content_tag(:td, link_to(fa_icon(:file_export), commission_path(deal.commission, :format => :pdf), :title => 'Print Preview of Rental Request for Commission'))
    else
      columns << content_tag(:td, link_to(fa_icon(:newspaper), new_commission_path(:deal_id => deal.id), :title => 'Begin Paperwork'))
    end
    
    columns << content_tag(:td, deal.documents.present? ? link_to(fa_icon(:hdd, :text => "(#{deal.documents.count})"), documents_path(:filtered_attribute => :deal_id, :filter_value => deal), :title => pluralize(deal.documents.count, 'Uploaded Document')) : '', :class => 'document_list')
    
    if current_agent.admin?
      columns << content_tag(:td, link_to(fa_icon(:joint, :class => 'deletion'), deal, :title => 'Delete Deal and its Assists', :method => :delete, :remote => true, :data => {:confirm => 'Are you sure?'}))
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
