class Lease < ApplicationRecord
  belongs_to :landlord, :optional => true
  has_many :tenants
  has_many :clients, :through => :tenants
  belongs_to :registration
  validates :street_number, :presence => true
  validates :street_name, :presence => true
  
  def name
    "#{street_number} #{street_name} with #{landlord.name}"
  end
end
