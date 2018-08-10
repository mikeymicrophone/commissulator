class DealHasCommission < ActiveRecord::Migration[5.2]
  def change
    add_column :deals, :commission, :float
  end
end
