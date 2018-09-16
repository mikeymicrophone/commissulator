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
  
  def fub_people
    people = []
    clients.each do |client|
      person = FubClient::Person.new :firstName => client.first_name, :lastName => client.last_name, :stage => 'Registered'
      person.phones = client.phones.map { |phone| {:value => phone.number, :type => phone.variety} } if client.phones.present?
      person.emails = client.emails.map { |email| {:value => email.address, :type => email.variety} } if client.emails.present?
      people << person
    end
    people
  end
  
  def follow_up!
    fub_people.each do |person|
      begin
        FubClient::Person.collection_path '/v1/people?deduplicate=true'
        person.save
      rescue NoMethodError => error
        Rails.logger.debug error.inspect
      end
    end
  end
end
