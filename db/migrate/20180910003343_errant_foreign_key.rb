class ErrantForeignKey < ActiveRecord::Migration[5.2]
  def change
    remove_foreign_key :registrations, :avatars
  end
end
