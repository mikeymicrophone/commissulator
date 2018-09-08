class Registration < ApplicationRecord
  belongs_to :referral_source, :optional => true
  belongs_to :agent, :optional => true
  
  def name
    "Reg on #{created_at.strftime "%-m/%-d"}"
  end
end
