class CreatePackages < ActiveRecord::Migration[5.2]
  def change
    create_table :packages do |t|
      t.string :name
      t.json :splits
      t.boolean :active

      t.timestamps
    end
  end
end
