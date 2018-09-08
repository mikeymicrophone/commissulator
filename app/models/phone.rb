class Phone < ApplicationRecord
  belongs_to :client, :optional => true
  belongs_to :employer, :optional => true
  validates :number, :presence => true
end
