class Lease < ApplicationRecord
  belongs_to :landlord, :optional => true
  belongs_to :client
  belongs_to :registration
end
