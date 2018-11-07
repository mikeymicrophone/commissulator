class Phone < ApplicationRecord
  include Sluggable

  belongs_to :client, :optional => true
  belongs_to :employer, :optional => true
  validates :number, :presence => true
  
  scope :home, lambda { where :variety => :home }
  scope :cell, lambda { where :variety => :cell }
  scope :office, lambda { where :variety => :office }
  scope :hiring, lambda { where :variety => :hiring }
  
  VARIETIES = ['cell', 'home', 'work', 'office']

  def to_param
    basic_slug client.first_name, client.last_name, variety
  end
  
  def name
    number
  end
end
