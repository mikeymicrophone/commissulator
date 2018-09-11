class Role < ApplicationRecord
  has_many :involvements
  has_many :packages, :through => :involvements
  has_many :deals, :through => :packages
  has_many :assists
  has_many :agents, :through => :assists
  
  attr_default :active, true
end
