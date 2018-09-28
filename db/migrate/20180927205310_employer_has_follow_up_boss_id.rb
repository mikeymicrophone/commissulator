class EmployerHasFollowUpBossId < ActiveRecord::Migration[5.2]
  def change
    add_column :employers, :follow_up_boss_id, :integer
  end
end
