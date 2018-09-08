class Employer < ApplicationRecord
  has_many :employments, :dependent => :destroy
  has_many :niches, :dependent => :destroy
  validates :name, :presence => true
end
