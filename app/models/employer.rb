class Employer < ApplicationRecord
  has_many :employments, :dependent => :destroy
  has_many :niches, :dependent => :destroy
  has_many :industries, :through => :niches
  validates :name, :presence => true
end
