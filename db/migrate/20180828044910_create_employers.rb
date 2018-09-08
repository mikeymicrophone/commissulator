class CreateEmployers < ActiveRecord::Migration[5.2]
  def change
    create_table :employers do |t|
      t.string :name
      t.string :address
      t.string :url

      t.timestamps
    end
  end
end
