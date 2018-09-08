class Employer < ApplicationRecord
  has_many :employments, :dependent => :destroy
  has_many :niches, :dependent => :destroy
  has_many :industries, :through => :niches
  has_many :emails
  has_many :phones
  has_many :social_accounts
  validates :name, :presence => true
end
