class CommissionHasLease < ActiveRecord::Migration[5.2]
  def change
    add_column :commissions, :lease_id, :integer
  end
end
