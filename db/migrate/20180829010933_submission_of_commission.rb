class SubmissionOfCommission < ActiveRecord::Migration[5.2]
  def change
    add_column :commissions, :submitted_on, :datetime
  end
end
