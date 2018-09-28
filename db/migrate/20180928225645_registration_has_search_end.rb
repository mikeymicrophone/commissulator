class RegistrationHasSearchEnd < ActiveRecord::Migration[5.2]
  def change
    add_column :registrations, :move_by_latest, :datetime
    add_column :registrations, :what_if_we_fail, :text
  end
end
