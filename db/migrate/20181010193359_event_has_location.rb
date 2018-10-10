class EventHasLocation < ActiveRecord::Migration[5.2]
  def change
    add_column :calendar_events, :location, :string
  end
end
