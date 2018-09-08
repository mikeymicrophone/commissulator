class CreateEmails < ActiveRecord::Migration[5.2]
  def change
    create_table :emails do |t|
      t.string :variety
      t.string :address
      t.belongs_to :client, foreign_key: true
      t.belongs_to :employer, foreign_key: true

      t.timestamps
    end
  end
end
