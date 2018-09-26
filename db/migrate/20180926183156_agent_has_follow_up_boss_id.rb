class AgentHasFollowUpBossId < ActiveRecord::Migration[5.2]
  def change
    add_column :agents, :follow_up_boss_id, :integer
  end
end
