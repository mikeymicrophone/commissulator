class ParticipantSplit < ActiveRecord::Migration[5.2]
  def change
    add_column :participants, :rate, :decimal
    add_column :assistants, :rate, :decimal
  end
end
