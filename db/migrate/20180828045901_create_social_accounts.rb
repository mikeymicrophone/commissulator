class CreateSocialAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :social_accounts do |t|
      t.string :variety
      t.string :url
      t.string :moniker
      t.belongs_to :client, foreign_key: true
      t.belongs_to :employer, foreign_key: true

      t.timestamps
    end
  end
end
