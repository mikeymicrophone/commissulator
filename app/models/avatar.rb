class Avatar < ApplicationRecord
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  has_one :agent
  has_many :deals, :through => :agent
  has_many :assists, :through => :deals
  has_many :agents, -> { distinct }, :through => :assists
  has_many :commissions, :through => :agent
  
  scope :alpha, lambda { order :first_name }
  
  def name
    "#{first_name} #{last_name}"
  end
  
  def reference
    if first_name.present?
      "#{first_name}"
    else
      email
    end
  end
end
