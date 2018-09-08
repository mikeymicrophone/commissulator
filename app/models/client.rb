class Client < ApplicationRecord
  has_many :registrants, :dependent => :destroy
  has_many :registrations, :through => :registrants
  has_many :emails
  has_many :phones
  has_many :social_accounts
  has_many :employments, :dependent => :destroy
  has_many :employers, :through => :employments
  has_many :industries, :through => :employers
  
  def name
    "#{first_name} #{last_name}"
  end
end
