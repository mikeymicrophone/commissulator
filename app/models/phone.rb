class Phone < ApplicationRecord
  belongs_to :client, :optional => true
  belongs_to :employer, :optional => true
  validates :number, :presence => true
  
  scope :home, lambda { where :variety => :home }
  scope :cell, lambda { where :variety => :cell }
  scope :office, lambda { where :variety => :office }
  scope :hiring, lambda { where :variety => :hiring }
  
  VARIETIES = ['cell', 'home', 'work', 'office']
  
  def name
    number
  end
end
