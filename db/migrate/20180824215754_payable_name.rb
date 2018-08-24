class PayableName < ActiveRecord::Migration[5.2]
  def change
    add_column :assistants, :payable_first_name, :string
    add_column :assistants, :payable_last_name, :string
  end
end
