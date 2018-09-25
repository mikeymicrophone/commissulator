class CreateTenants < ActiveRecord::Migration[5.2]
  def change
    create_table :tenants do |t|
      t.belongs_to :client, foreign_key: true
      t.belongs_to :lease, foreign_key: true

      t.timestamps
    end
    
    Lease.find_each do |lease|
      Tenant.create :lease => lease, :client => lease.client
    end
    
    remove_column :leases, :client_id
  end
end
