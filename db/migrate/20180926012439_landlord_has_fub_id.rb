class LandlordHasFubId < ActiveRecord::Migration[5.2]
  def change
    add_column :landlords, :follow_up_boss_id, :integer
  end
end
