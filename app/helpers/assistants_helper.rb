module AssistantsHelper
  def assistant_adder deal
    form_with :model => Assistant.new, :id => 'assistant_adder' do |form|
      form.text_field(:first_name, :placeholder => 'First Name', :size => 15) +
      form.text_field(:last_name, :placeholder => 'Last Name', :size => 15) +
      form.submit('Add Name') +
      hidden_field(:deal, :id, :value => deal.id)
    end
  end
  
  def activation_of assistant
    if assistant.status == 'active'
      link_to 'Deactivate', assistant_path(assistant, :assistant => {:status => :inactive}), :method => :patch, :remote => true, :id => dom_id(assistant, :activation_of)
    else
      link_to 'Activate', assistant_path(assistant, :assistant => {:status => :active}), :method => :patch, :remote => true, :id => dom_id(assistant, :activation_of)
    end
  end
end
