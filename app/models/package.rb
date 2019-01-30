class Package < ApplicationRecord
  include Sluggable

  has_many :deals
  has_many :involvements, :dependent => :destroy
  has_many :roles, :through => :involvements
  
  attr_default :active, true
  
  def self.default
    find ENV['DEFAULT_PACKAGE_ID']
  end

  def to_param
    basic_slug name
  end
end
