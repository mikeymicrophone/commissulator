class SignatureOnRegistration < ActiveRecord::Migration[5.2]
  def change
    add_column :registrations, :signature, :string
  end
end
