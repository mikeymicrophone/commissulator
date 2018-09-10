module AgentsHelper
  def agent_adder deal
    form_with :model => Agent.new, :id => 'agent_adder' do |form|
      form.text_field(:first_name, :placeholder => 'First Name', :size => 15) +
      form.text_field(:last_name, :placeholder => 'Last Name', :size => 15) +
      form.submit('Add Name') +
      hidden_field(:deal, :id, :value => deal.id)
    end
  end
  
  def activation_of agent
    if agent.status == 'active'
      link_to 'Deactivate', agent_path(agent, :agent => {:status => :inactive}), :method => :patch, :remote => true, :id => dom_id(agent, :activation_of)
    else
      link_to 'Activate', agent_path(agent, :agent => {:status => :active}), :method => :patch, :remote => true, :id => dom_id(agent, :activation_of)
    end
  end
end
