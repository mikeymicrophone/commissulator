class AvatarActivation < ActiveRecord::Migration[5.2]
  def change
    add_column :avatars, :activated, :boolean, :default => false, :null => false
    add_index  :avatars, :activated
  end
end
