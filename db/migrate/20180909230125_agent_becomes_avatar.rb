class AgentBecomesAvatar < ActiveRecord::Migration[5.2]
  def change
    remove_index :agents, :confirmation_token
    remove_index :agents, :email
    remove_index :agents, :reset_password_token

    rename_table :agents, :avatars

    add_index :avatars, :confirmation_token
    add_index :avatars, :email
    add_index :avatars, :reset_password_token

    rename_column :assistants, :agent_id, :avatar_id
    rename_column :documents, :agent_id, :avatar_id
  end
end
