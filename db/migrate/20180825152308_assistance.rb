class Assistance < ActiveRecord::Migration[5.2]
  def change
    rename_table :participants, :assists
  end
end
