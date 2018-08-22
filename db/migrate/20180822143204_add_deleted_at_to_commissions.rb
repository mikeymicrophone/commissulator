class AddDeletedAtToCommissions < ActiveRecord::Migration[5.2]
  def change
    add_column :commissions, :deleted_at, :datetime
    add_index :commissions, :deleted_at
  end
end
