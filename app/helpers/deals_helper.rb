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
      content_tag(:td, link_to('Breakdown', deal)),
      content_tag(:td, link_to('Edit', edit_deal_path(deal))),
      content_tag(:td, link_to(pluralize(deal.documents.count, 'document'), documents_path(:filtered_attribute => :deal_id, :filter_value => deal))),
      content_tag(:td, link_to('Attach', new_document_path(:document => {:deal_id => deal})))
    ]
    
    if deal.commission
      columns << content_tag(:td, link_to('Paperwork', edit_commission_path(deal.commission)))
      columns << content_tag(:td, link_to('Printout', commission_path(deal.commission, :format => :pdf)))
    else
      columns << content_tag(:td, link_to('Paperwork', new_commission_path(:deal_id => deal.id)))
    end
    
    if current_agent.admin?
      columns << content_tag(:td, link_to('Delete', deal, :method => :delete, :remote => true))
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
