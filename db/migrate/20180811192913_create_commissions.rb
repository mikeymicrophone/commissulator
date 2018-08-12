class CreateCommissions < ActiveRecord::Migration[5.2]
  def change
    create_table :commissions do |t|
      t.belongs_to :deal
      t.belongs_to :agent
      t.belongs_to :landlord
      
      t.string :branch_name
      t.string :tenant_name#, :array => true, :default => []
      t.string :tenant_email#, :array => true, :default => []
      t.string :tenant_phone_number#, :array => true, :default => []
      t.string :landlord_name
      t.string :landlord_email
      t.string :landlord_phone_number
      t.string :agent_name
      
      t.string :bedrooms
      t.string :property_type
      t.boolean :new_development
      t.date :lease_start_date
      t.date :lease_term_date
      t.integer :square_footage
      t.integer :listed_monthly_rent
      
      t.string :landlord_source
      t.string :tenant_source
      
      t.integer :intranet_deal_number
      t.boolean :copy_of_lease
      t.string :property_address
      t.string :apartment_number
      t.string :zip_code

      t.date :lease_sign_date
      t.date :approval_date
      t.integer :leased_monthly_rent
      t.float :commission_fee_percentage
      t.float :agent_split_percentage
      t.float :owner_pay_commission
      t.float :listing_side_commission
      t.float :tenant_side_commission
      t.text :reason_for_fee_reduction
      
      t.date :request_date
      t.float :annualized_rent
      t.float :total_commission
      t.float :citi_commission
      t.float :co_broke_commission

      t.timestamps
    end
  end
end
