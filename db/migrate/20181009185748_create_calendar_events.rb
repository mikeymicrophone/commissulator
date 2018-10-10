class CreateCalendarEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :calendar_events do |t|
      t.string :title
      t.text :description
      t.datetime :start_time
      t.datetime :end_time
      t.json :invitees
      t.integer :follow_up_boss_id
      t.integer :google_id
      t.integer :calendly_id
      t.integer :agent_id
      t.datetime :confirmed_at

      t.timestamps
    end
  end
end
