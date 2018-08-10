module DealsHelper
  def participant_adder deal
    form_with :model => deal.participants.new do |form|
      form.select(:role, Participant.roles.keys) +
      form.select(:assistant_id, options_from_collection_for_select(Assistant.all, :id, :name)) +
      form.submit(:add) +
      form.hidden_field(:deal_id)
    end 
  end
end
