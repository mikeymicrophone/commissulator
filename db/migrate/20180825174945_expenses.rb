class Expenses < ActiveRecord::Migration[5.2]
  def change
    add_column :assists, :expense, :decimal
  end
end
