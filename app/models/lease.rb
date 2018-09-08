class Lease < ApplicationRecord
  belongs_to :landlord, :optional => true
  belongs_to :client
  belongs_to :registration
  validates :street_number, :presence => true
  validates :street_name, :presence => true
end
