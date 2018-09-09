class Registration < ApplicationRecord
  belongs_to :referral_source, :optional => true
  belongs_to :agent, :optional => true
  has_many :registrants, :dependent => :destroy
  has_many :clients, :through => :registrants
  has_many :apartments, :dependent => :destroy
  has_many :leases, :dependent => :destroy
  has_many :landlords, :through => :leases
  has_many :employments, :through => :clients
  
  def name
    "Reg #{id} on #{created_at.strftime "%-m/%-d"}"
  end
  
  PRICES = (2..30).to_a.map { |num| num * 500 }.append(1250, 1750, 2250).sort
  APARTMENT_SIZES = ['Alcove Studio', 'Junior-1', 'Studio', 'One Bedroom', 'Junior-4', 'Convertible-2', 'Two Bedroom', 'Convertible-3', 'Classic-6', 'Three Bedroom', 'Classic-7', 'Convertible-4', 'Four Bedroom', 'Five Bedroom+']
end
