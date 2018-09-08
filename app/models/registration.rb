class Registration < ApplicationRecord
  belongs_to :referral_source, :optional => true
  belongs_to :agent, :optional => true
  has_many :registrants, :dependent => :destroy
  has_many :clients, :through => :registrants
  
  def name
    "Reg #{id} on #{created_at.strftime "%-m/%-d"}"
  end
end
