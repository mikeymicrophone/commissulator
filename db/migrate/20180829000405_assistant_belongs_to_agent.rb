class AssistantBelongsToAgent < ActiveRecord::Migration[5.2]
  def change
    add_column :assistants, :agent_id, :integer
  end
end
