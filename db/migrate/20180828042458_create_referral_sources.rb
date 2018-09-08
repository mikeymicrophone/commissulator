class CreateReferralSources < ActiveRecord::Migration[5.2]
  def change
    create_table :referral_sources do |t|
      t.string :name
      t.boolean :active

      t.timestamps
    end
  end
end
