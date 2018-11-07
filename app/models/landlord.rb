class Landlord < ApplicationRecord
  include Sluggable

  has_many :commissions
  has_many :leases

  def to_param
    basic_slug name
  end
  
  def recent_commission
    commissions.order('approval_date desc nulls last').first
  end
  
  def fub_create
    first_name = name.split.first
    last_name = name.split[1..-1]&.join ' '
    begin
      similar_people = FubClient::Person.where(:firstName => first_name, :lastName => last_name).fetch
      person = similar_people.first if similar_people.present?
      person ||= FubClient::Person.new :firstName => first_name, :lastName => last_name
      person.emails = [{:value => email}] if email.present?
      person.phones = [{:value => phone_number, :type => 'work'}] if phone_number.present?
      person.tags = ['Landlord']
      person.stage = ENV['FOLLOW_UP_BOSS_STAGE_ID_LANDLORD']
      update_attribute :follow_up_boss_id, person.id
      person.save
    rescue NoMethodError => error
      Rails.logger.debug error.inspect
    end
    person
  end
  
  def fub_person
    FubClient::Person.find(follow_up_boss_id) || fub_create
  end
  
  def follow_up_boss_url
    "https://#{Rails.application.credentials.follow_up_boss[:subdomain]}.followupboss.com/2/people/view/#{follow_up_boss_id}" if follow_up_boss_id.present?
  end
end
