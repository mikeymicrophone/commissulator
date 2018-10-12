class GoogleEventIdIsAString < ActiveRecord::Migration[5.2]
  def change
    change_column :calendar_events, :google_id, :string
  end
end
