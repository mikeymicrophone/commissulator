class CreateRegistrants < ActiveRecord::Migration[5.2]
  def change
    create_table :registrants do |t|
      t.text :other_fund_sources
      t.belongs_to :client, foreign_key: true
      t.belongs_to :registration, foreign_key: true

      t.timestamps
    end
  end
end
