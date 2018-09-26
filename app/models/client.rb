class Client < ApplicationRecord
  has_many :registrants, :dependent => :destroy
  has_many :registrations, :through => :registrants
  has_many :apartments, :through => :registrations
  has_many :landlords, :through => :registrations
  has_many :emails
  has_many :phones
  has_many :social_accounts
  has_many :employments, :dependent => :destroy
  has_many :employers, :through => :employments
  has_many :industries, :through => :employers
  has_many :tenants
  has_many :leases, :through => :tenants
  has_many :commissions, :through => :leases
  
  def name
    "#{first_name} #{last_name}"
  end
  
  def fub_create
    similar_people = FubClient::Person.where(:firstName => first_name, :lastName => last_name).fetch
    person = similar_people.first if similar_people.present?
    person ||= FubClient::Person.new :firstName => first_name, :lastName => last_name
    person.emails = emails.map { |email| {:value => email.address} } if emails.any?
    person.phones = phones.map { |phone| {:value => phone.number, :type => phone.variety} } if phones.any?
    begin
      person.save
    rescue NoMethodError => error
      Rails.logger.debug error.inspect
    end
    update_attribute :follow_up_boss_id, person.id
    person
  end
  
  def fub_update attrs
    url = URI "https://api.followupboss.com/v1/people/#{follow_up_boss_id}"
    http = Net::HTTP.new url.host, url.port
    http.use_ssl = true
    request = Net::HTTP::Put.new url
    request.basic_auth FubClient::Client.instance.api_key, ''
    request.body = attrs.to_query
    response = http.request request
  end
  
  def fub_sync attrs
    if fub_person
      fub_update attrs
    else
      fub_create
      fub_update attrs
    end
  end
  
  def fub_lease_closing deal
    fub_sync fub_bio.merge(fub_contacts).merge(fub_financials deal)
  end
  
  def fub_bio
    {:firstName => first_name, :lastName => last_name}
  end
  
  def fub_contacts
    contacts = {}
    contacts[:emails] = emails.map { |email| {:value => email.address} } if emails.any?
    contacts[:phones] = phones.map { |phone| {:value => phone.number, :type => phone.variety} } if phones.any?
    contacts
  end
  
  def fub_financials deal
    {
      :stage => 'Closed',
      :customCommission => deal.total_commission,
      :customCloseDate => deal.lease_sign_date,
      :customLeaseEndDate => deal.lease_end_date,
      :price => deal.leased_monthly_rent
    }
  end
  
  def fub_person
    @fub_person ||= FubClient::Person.find(follow_up_boss_id) || fub_create
  end
  
  def detail_deal deal
    fub_person.stage = 'Closed'
    fub_person.customCommission = deal.total_commission
    fub_person.customCloseDate = deal.lease_sign_date
    fub_person.customLeaseEndDate = deal.lease_end_date
    fub_person.price = deal.leased_monthly_rent
    fub_person.save
  end
end
