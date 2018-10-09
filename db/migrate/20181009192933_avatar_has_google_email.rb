class AvatarHasGoogleEmail < ActiveRecord::Migration[5.2]
  def change
    add_column :avatars, :google_email, :string
  end
end
