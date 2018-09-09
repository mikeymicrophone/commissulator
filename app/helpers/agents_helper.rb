module AgentsHelper
  def agent_new_registration_path agent
    link_to 'Register Client', begin_registration_path(:agent_id => agent)
  end
  
  def weekly_deals_by agent
    link_to "(#{agent.deals.this_week.count} this week)", deals_path(:filtered_attribute => :agent_id, :filter_value => agent, :cutoff => 1.week.ago)
  end
  
  def deals_by agent
    link_to pluralize(agent.deals.count, 'Deal'), deals_path(:filtered_attribute => :agent_id, :filter_value => agent)
  end
  
  def commissions_for agent
    link_to pluralize(agent.commissions.count, 'Commission'), commissions_path(:filtered_attribute => :agent_id, :filter_value => agent)
  end
  
  def assistants_of agent
    link_to pluralize(agent.assistants.count, 'Assistant'), assistants_path(:filtered_attribute => :agent_id, :filter_value => agent)
  end
end
