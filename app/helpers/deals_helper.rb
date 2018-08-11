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
end
