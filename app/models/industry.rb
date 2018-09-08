class Industry < ApplicationRecord
  has_many :niches, :dependent => :destroy
  validates :name, :presence => true
end
