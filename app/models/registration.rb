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
    people = []
    clients.each do |client|
      person = FubClient::Person.new :firstName => client.first_name, :lastName => client.last_name, :stage => 'Registered'
      person.phones = client.phones.map { |phone| {:value => phone.number, :type => phone.variety} } if client.phones.present?
      person.emails = client.emails.map { |email| {:value => email.address} } if client.emails.present?
      people << person
    end
    people
  end
  
  def fub_employers
    employer_people = []
    employers.each do |employer|
      employer_person = FubClient::Person.new :lastName => employer.name, :tags => ['Employer']
      employer_person.addresses = [employer.address] if employer.address.present?
      employer_person.phones = employer.phones.where(:client_id => nil).map { |phone| {:value => phone.number, :type => phone.variety} } if employer.phones.present?
      employer_person.emails = employer.emails.where(:client_id => nil).map { |email| {:value => email.address} } if employer.emails.present?
      employer_people << employer_person
    end
    employer_people
  end
  
  def follow_up!
    FubClient::Person.collection_path '/v1/people?deduplicate=true'
    fub_people.each do |person|
      begin
        person.save
      rescue NoMethodError => error
        Rails.logger.debug error.inspect
      end
    end
    fub_employers.each do |employer|
      begin
        employer.save
      rescue NoMethodError => error
        Rails.logger.debug error.inspect
      end
    end
  end
end
