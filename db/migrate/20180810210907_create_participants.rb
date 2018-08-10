class CreateParticipants < ActiveRecord::Migration[5.2]
  def change
    create_table :participants do |t|
      t.belongs_to :deal, foreign_key: true
      t.belongs_to :assistant, foreign_key: true
      t.integer :role
      t.integer :status

      t.timestamps
    end
  end
end
