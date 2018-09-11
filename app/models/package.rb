class Package < ApplicationRecord
  has_many :deals
  has_many :involvements
  has_many :roles, :through => :involvements
  
  attr_default :active, true
end
