class Client < ApplicationRecord
  has_many :registrants, :dependent => :destroy
  has_many :registrations, :through => :registrants
  has_many :emails
  has_many :phones
  has_many :social_accounts
  
  def name
    "#{first_name} #{last_name}"
  end
end
