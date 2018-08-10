class CreateDeals < ActiveRecord::Migration[5.2]
  def change
    create_table :deals do |t|
      t.string :name
      t.text :address
      t.string :unit_number
      t.integer :status
      t.belongs_to :agent

      t.timestamps
    end
  end
end
