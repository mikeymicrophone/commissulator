class ConsolidateCommissionAccounting < ActiveRecord::Migration[5.2]
  def change
    remove_column :deals, :commission
  end
end
