class Package < ApplicationRecord
  has_many :deals
  has_many :involvements, :dependent => :destroy
  has_many :roles, :through => :involvements
  
  attr_default :active, true
end
