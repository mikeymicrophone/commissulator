class CreatePhones < ActiveRecord::Migration[5.2]
  def change
    create_table :phones do |t|
      t.string :variety
      t.string :number
      t.belongs_to :client, foreign_key: true
      t.belongs_to :employer, foreign_key: true

      t.timestamps
    end
  end
end
