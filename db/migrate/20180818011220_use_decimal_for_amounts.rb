class UseDecimalForAmounts < ActiveRecord::Migration[5.2]
  def change
    change_column :commissions, :bedrooms, 'decimal using bedrooms::numeric'
    change_column :commissions, :square_footage, :decimal
    change_column :commissions, :listed_monthly_rent, :decimal
    change_column :commissions, :leased_monthly_rent, :decimal
    change_column :commissions, :annualized_rent, :decimal
    
    change_column :commissions, :commission_fee_percentage, :decimal
    change_column :commissions, :agent_split_percentage, :decimal
    change_column :commissions, :owner_pay_commission, :decimal
    change_column :commissions, :listing_side_commission, :decimal
    change_column :commissions, :tenant_side_commission, :decimal
    change_column :commissions, :total_commission, :decimal
    change_column :commissions, :citi_commission, :decimal
    change_column :commissions, :co_broke_commission, :decimal
    
    change_column :commissions, :referral_payment, :decimal
    change_column :commissions, :citi_habitats_referral_agent_amount, :decimal
    change_column :commissions, :corcoran_referral_agent_amount, :decimal
    change_column :commissions, :outside_agency_amount, :decimal
    change_column :commissions, :relocation_referral_amount, :decimal
    change_column :commissions, :listing_fee_percentage, :decimal
  end
end
