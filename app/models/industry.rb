class Industry < ApplicationRecord
  include Sluggable

  has_many :niches, :dependent => :destroy
  has_many :employers, :through => :niches
  has_many :clients, :through => :employers
  has_many :employments, :through => :employers
  has_many :emails, :through => :employers
  has_many :phones, :through => :employers
  has_many :social_accounts, :through => :employers
  validates :name, :presence => true, :uniqueness => true

  def to_param
    basic_slug name
  end
end
