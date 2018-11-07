class Role < ApplicationRecord
  include Sluggable

  has_many :involvements
  has_many :packages, :through => :involvements
  has_many :deals, :through => :packages
  has_many :assists
  has_many :agents, :through => :assists
  
  attr_default :active, true

  def to_param
    basic_slug name
  end
end
