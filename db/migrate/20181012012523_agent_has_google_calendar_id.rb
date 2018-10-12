class AgentHasGoogleCalendarId < ActiveRecord::Migration[5.2]
  def change
    add_column :agents, :google_calendar_id, :string
  end
end
