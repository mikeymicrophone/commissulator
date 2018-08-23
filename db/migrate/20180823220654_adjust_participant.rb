class AdjustParticipant < ActiveRecord::Migration[5.2]
  def change
    add_column :participants, :adjustment, :decimal
  end
end
