class CreateLeases < ActiveRecord::Migration[5.2]
  def change
    create_table :leases do |t|
      t.string :apartment_number
      t.string :street_number
      t.string :street_name
      t.string :zip_code
      t.belongs_to :landlord, foreign_key: true
      t.belongs_to :client, foreign_key: true
      t.belongs_to :registration, foreign_key: true

      t.timestamps
    end
  end
end
