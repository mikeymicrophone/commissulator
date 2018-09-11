class CreateRoles < ActiveRecord::Migration[5.2]
  def change
    create_table :roles do |t|
      t.string :name
      t.decimal :rate
      t.boolean :active

      t.timestamps
    end
  end
end
