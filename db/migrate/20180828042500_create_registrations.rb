class CreateRegistrations < ActiveRecord::Migration[5.2]
  def change
    create_table :registrations do |t|
      t.decimal :minimum_price
      t.decimal :maximum_price
      t.string :size
      t.date :move_by
      t.text :reason_for_moving
      t.integer :occupants
      t.string :pets
      t.belongs_to :referral_source, foreign_key: true
      t.belongs_to :agent, foreign_key: true

      t.timestamps
    end
  end
end
