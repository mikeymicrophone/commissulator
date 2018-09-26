class DealHasFollowUpBossId < ActiveRecord::Migration[5.2]
  def change
    add_column :deals, :follow_up_boss_id, :integer
  end
end
