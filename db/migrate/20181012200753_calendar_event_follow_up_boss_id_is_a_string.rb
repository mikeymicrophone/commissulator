class CalendarEventFollowUpBossIdIsAString < ActiveRecord::Migration[5.2]
  def change
    change_column :calendar_events, :follow_up_boss_id, :string
  end
end
