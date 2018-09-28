class Employer < ApplicationRecord
  has_many :employments, :dependent => :destroy
  has_many :clients, :through => :employments
  has_many :niches, :dependent => :destroy
  has_many :industries, :through => :niches
  has_many :emails
  has_many :phones
  has_many :social_accounts
  validates :name, :presence => true
  
  def fub_create
    similar_people = FubClient::Person.where(:lastName => name).fetch
    person = similar_people.first if similar_people.present?
    person ||= FubClient::Person.new :lastName => name
    person.emails = emails.map { |email| {:value => email.address} } if emails.any?
    person.phones = phones.map { |phone| {:value => phone.number, :type => phone.variety} } if phones.any?
    person.tags = ['Employer']
    person.stage = ENV['FOLLOW_UP_BOSS_STAGE_ID_EMPLOYER']
    begin
      person.save
    rescue NoMethodError => error
      Rails.logger.debug error.inspect
    end
    update_attribute :follow_up_boss_id, person.id
    person
  end
  
  def fub_person
    FubClient::Person.find(follow_up_boss_id) || fub_create
  end
end
