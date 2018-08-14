class Landlord < ApplicationRecord
  has_many :commissions
  
  def recent_commission
    commissions.order('approval_date desc nulls last').first
  end
end
