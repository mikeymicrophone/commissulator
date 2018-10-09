class Agent < ApplicationRecord
  has_many :assists, :dependent => :nullify
  belongs_to :avatar, :optional => true
  has_many :deals
  has_many :commissions
  has_many :registrations
  
  has_many_attached :cookies
  
  enum :status => [:active, :inactive]
  attr_default :status, 'active'
  
  scope :active, lambda { where :status => 'active' }
  scope :alpha, lambda { order :first_name }
  
  def name
    "#{first_name} #{last_name}"
  end
  
  def payable_name
    if payable_first_name.present?
      "#{payable_first_name} #{payable_last_name}"
    else
      name
    end
  end
  
  def distinct_payable_name
    "#{payable_first_name} #{payable_last_name}"
  end
  
  def fub_user
    FubClient::User.find follow_up_boss_id
  end
end
