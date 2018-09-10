class AttributeDealsToSenior < ActiveRecord::Migration[5.2]
  def change
    agent = Agent.where(:first_name => ENV['SENIOR_AGENT_FIRST_NAME']).take
    
    # this logic isn't completely tuned up for this migration but in the case of my deploy it will work
    Deal.update_all :agent_id => agent.id
    Commission.update_all :agent_id => agent.id
  end
end
