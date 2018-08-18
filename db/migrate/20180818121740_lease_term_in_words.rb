class LeaseTermInWords < ActiveRecord::Migration[5.2]
  def change
    change_column :commissions, :lease_term_date, :string
    rename_column :commissions, :lease_term_date, :lease_term
  end
end
