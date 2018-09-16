class AddOmniauthToAvatars < ActiveRecord::Migration[5.2]
  def change
    add_column :avatars, :provider, :string
    add_index :avatars, :provider
    add_column :avatars, :uid, :string
    add_index :avatars, :uid
  end
end
