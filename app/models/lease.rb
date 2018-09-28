class Lease < ApplicationRecord
  belongs_to :landlord, :optional => true
  has_many :tenants
  has_many :clients, :through => :tenants
  has_one :commission
  belongs_to :registration, :optional => true
  # validates :street_number, :presence => true
  # validates :street_name, :presence => true
  
  def name
    "#{address} with #{landlord&.name}"
  end
  
  def address
    "#{street_number} #{street_name}"
  end
end
