class Registration < ApplicationRecord
  belongs_to :referral_source, :optional => true
  belongs_to :agent, :optional => true
  has_many :registrants, :dependent => :destroy
  has_many :clients, :through => :registrants
  has_many :apartments, :dependent => :destroy
  has_many :leases, :dependent => :destroy
  has_many :landlords, :through => :leases
  has_many :employments, :through => :clients
  has_many :employers, :through => :employments
  
  def name
    "Reg #{id} on #{created_at.strftime "%-m/%-d"}"
  end
  
  PRICES = (2..30).to_a.map { |num| num * 500 }.append(1250, 1750, 2250).sort
  APARTMENT_SIZES = ['Alcove Studio', 'Junior-1', 'Studio', 'One Bedroom', 'Junior-4', 'Convertible-2', 'Two Bedroom', 'Convertible-3', 'Classic-6', 'Three Bedroom', 'Classic-7', 'Convertible-4', 'Four Bedroom', 'Five Bedroom+']
  
  def fub_people
    clients.map &:fub_person
  end
  
  def fub_employers
    employers.map &:fub_person
  end
  
  def fub_landlords
    landlords.map &:fub_person
  end
  
  def follow_up!
    fub_people.each do |person|
      begin
        event = FubClient::Event.new :type => 'Registration'
        event.person = person
        event.save
      rescue NoMethodError => error
        Rails.logger.debug error.inspect
      end
    end
    fub_employers
    fub_landlords
  end
end
