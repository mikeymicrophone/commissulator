module DealsHelper
  def participant_adder deal
    form_with :model => deal.participants.new do |form|
      form.select(:role, Participant.roles.keys) +
      form.select(:assistant_id, options_from_collection_for_select(Assistant.all, :id, :name)) +
      form.submit(:add) +
      form.hidden_field(:deal_id)
    end 
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
      content_tag(:td, number_to_currency(deal.commission)),
      content_tag(:td, deals_by(deal.agent)),
      content_tag(:td, deal.address),
      content_tag(:td, deal.unit_number),
      content_tag(:td, status_clicker_for(deal)),
      content_tag(:td, deal.updated_at&.strftime("%a %-m/%-d %-I:%M%P")),
      content_tag(:td, link_to('Show', deal)),
      content_tag(:td, link_to('Edit', edit_deal_path(deal)))
    ]
    
    content_tag :tr, columns.join.html_safe
  end
  
  def fabricate_deal_link opts = {}
    if params[:filtered_attribute] == 'agent_id'
      opts[:agent_id] = params[:filter_value]
    end
    link_to "Fabricate #{opts[:status]} deal", fabricate_deals_path(:deal => opts), :method => :post, :remote => true
  end
end
