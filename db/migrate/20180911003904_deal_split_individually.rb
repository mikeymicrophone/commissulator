class DealSplitIndividually < ActiveRecord::Migration[5.2]
  def change
    add_column :deals, :package_id, :integer
    add_column :packages, :description, :text
  end
end
