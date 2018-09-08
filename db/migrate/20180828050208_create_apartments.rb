class CreateApartments < ActiveRecord::Migration[5.2]
  def change
    create_table :apartments do |t|
      t.string :unit_number
      t.string :street_number
      t.string :street_name
      t.string :zip_code
      t.string :size
      t.decimal :rent
      t.string :comment
      t.belongs_to :registration, foreign_key: true

      t.timestamps
    end
  end
end
