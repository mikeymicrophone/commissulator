class CreateEmployments < ActiveRecord::Migration[5.2]
  def change
    create_table :employments do |t|
      t.string :position
      t.decimal :income
      t.date :start_date
      t.belongs_to :client, foreign_key: true
      t.belongs_to :employer, foreign_key: true

      t.timestamps
    end
  end
end
