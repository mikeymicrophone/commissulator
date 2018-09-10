class AssistantBecomesAgent < ActiveRecord::Migration[5.2]
  def change
    rename_table :assistants, :agents
    
    rename_column :assists, :assistant_id, :agent_id
  end
end
