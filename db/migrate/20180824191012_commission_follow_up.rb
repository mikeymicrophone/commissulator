class CommissionFollowUp < ActiveRecord::Migration[5.2]
  def change
    add_column :commissions, :follow_up, :integer
  end
end
