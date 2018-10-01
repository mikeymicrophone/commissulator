include ActionView::Helpers::NumberHelper
require 'contactually'

class Commission < ApplicationRecord
  belongs_to :deal, :optional => true
  belongs_to :agent, :optional => true
  belongs_to :landlord, :optional => true
  has_many :documents, :through => :deal
  has_many :agents, :through => :deal, :source => :agents
  belongs_to :lease, :optional => true
  has_many :tenants, :through => :lease
  has_many :clients, :through => :tenants
  serialize :tenant_name
  serialize :tenant_email
  serialize :tenant_phone_number
  attr_default :tenant_name, []
  attr_default :tenant_email, []
  attr_default :tenant_phone_number, []
  attr_default :branch_name, 'Park Avenue South'
  attr_default :agent_name, 'Desmond Eaddy'
  attr_default :agent_split_percentage, ENV['SENIOR_AGENT_SPLIT_PERCENTAGE']
  attr_default :copy_of_lease, true
  attr_default :lease_start_date, lambda { Date.civil Date.today.next_month.year, Date.today.next_month.month, 1 }
  attr_default :lease_term, '12 months'
  # attr_default :owner_pay_commission, 0
  # attr_default :listing_side_commission, 0
  attr_default :reason_for_fee_reduction, 'N/A'
  
  before_save :trim_tenants
  before_create :meet_landlord, :name_agent
  after_save :address_deal, :assign_lease
  
  enum :follow_up => [:unsubmitted, :submitted]
  attr_default :follow_up, :unsubmitted
  
  scope :visible_to, lambda { |avatar| avatar.admin? ? all : assisted_by(avatar.agent) }
  scope :assisted_by, lambda { |agent| joins(:agents).where 'assists.agent_id' => agent }
  
  acts_as_paranoid
  
  def name
    deal.reference
  end
  
  def subcommission_payout_summary
    deal.subcommissions.inject("") { |summary, award| summary + "   #{award.first}: #{number_to_currency award.last}" }
  end
  
  def trim_tenants
    self.tenant_name.reject! &:blank?
    self.tenant_email.reject! &:blank?
    self.tenant_phone_number.reject! &:blank?
  end
  
  def meet_landlord
    self.landlord = Landlord.where(:name => landlord_name).take || Landlord.where(:name => landlord_name, :email => landlord_email, :phone_number => landlord_phone_number).create
  end
  
  def name_agent
    self.agent_name = agent.name
  end
  
  def address_deal
    deal.address = property_address
    deal.unit_number = apartment_number
    deal.save
  end
  
  def street_number
    address_pattern = /^([\d\-]+)\s+(.*)/
    matched_data = address_pattern.match property_address
    matched_data[1]
  end
  
  def street_name
    address_pattern = /^([\d\-]+)\s+(.*)/
    matched_data = address_pattern.match property_address
    matched_data[2]
  end
  
  def assign_lease
    lease = Lease.new
    lease.apartment_number = apartment_number
    lease.street_number = street_number
    lease.street_name = street_name
    lease.zip_code = zip_code
    lease.landlord_id = landlord_id
    lease.save
    update_column :lease_id, lease.id
  end
  
  def populate_lease
    assign_lease unless lease
  end
  
  def lease_end_date
    Timespan.new(:from => lease_start_date, :duration => lease_term).end_date
  end
  
  def tenant_clients
    group = []
    tenant_name.each_with_index do |name, index|
      first_name = name.split.first
      last_name = name.split[1..-1].join ' '
      client = Client.find_or_create_by :first_name => first_name, :last_name => last_name
      tenant = Tenant.find_or_create_by :client => client, :lease => lease
      email = Email.find_or_create_by :client => client, :address => tenant_email[index]
      phone = Phone.find_or_create_by :client => client, :number => tenant_phone_number[index]
      group << client
    end
    group
  end
  
  def fub_people
    tenant_clients.map &:fub_person
  end
  
  def fub_people_update
    tenant_clients.each { |client| client.fub_lease_closing deal }
  end
  
  def fub_landlord
    landlord.fub_person # doesn't currently append new contact info
  end
  
  def fub_deal
    @fub_deal ||= deal.fub_deal
  end
  
  def follow_up!
    fub_people_update
    fub_landlord
    fub_deal
    deal.fub_annotate_people
  end
  
  def contactually_people
    ctly_people = []
    clients.each do |client|
      payload = {:first_name => client.first_name, :last_name => client.last_name}
      payload[:addresses] = [{:label => 'current', :street_1 => property_address, :street_2 => apartment_number, :city => 'New York', :state => 'NY', :zip => zip_code, :country => 'United States'}]
      payload[:bucket_ids] = [ENV['CONTACTUALLY_CLOSED_BUCKET_ID']]
      payload[:email_addresses] = client.emails.map { |email| {:address => email.address, :label => email.variety} } if client.emails.any?
      payload[:phone_numbers] = client.phones.map { |phone| {:number => phone.number, :label => phone.variety} } if client.phones.any?
      ctly_people << payload
    end
    ctly_people
  end
  
  def contactually_up!
    responses = []
    contactually_people.each do |payload|
      responses << contactually_client.contacts.create(:data => payload)
    end
    responses
  end
  
  def boolean_display attribute
    'X' if attribute # '✓' if attribute
  end
  
  def located?
    property_address.present? && apartment_number.present? && zip_code.present?
  end
  
  def located_title
    "address, unit number and zip"
  end
  
  def populated?
    tenant_name&.first.present? && tenant_email.first.present? && tenant_phone_number.first.present?
  end
  
  def populated_title
    "tenant name, email, and phone"
  end
  
  def known?
    property_type.present? && bedrooms.present? && listed_monthly_rent.present?
  end
  
  def known_title
    "property type, bedrooms, and listed rent"
  end
  
  def owned?
    landlord_name.present? && landlord_email.present? && landlord_phone_number.present?
  end
  
  def owned_title
    "landlord name, email, phone"
  end
  
  def dealt?
    leased_monthly_rent.present? && annualized_rent.present? && lease_start_date.present? && lease_term.present? && tenant_side_commission.present?
  end
  
  def dealt_title
    "leased rent, annual rent, lease start date & term, tenant commission"
  end
  
  def brokered?
    ((co_exclusive_agency? && co_exclusive_agency_name.present?) ||
    (exclusive_agency? && exclusive_agency_name.present?) ||
    (exclusive_agent? && exclusive_agent_name.present? && exclusive_agent_office.present?) ||
    (open_listing?)) && (
    (citi_habitats_agent? && citi_habitats_agent_name.present? && citi_habitats_agent_office.present?) ||
    (corcoran_agent? && corcoran_agent_name.present? && corcoran_agent_office.present?) ||
    (co_broke_company? && co_broke_company_name.present?) ||
    (direct_deal?))
  end
  
  def brokered_title
    "deal source fully specified"
  end
  
  def referred?
    (citi_habitats_referral_agent? && citi_habitats_referral_agent_name.present? && citi_habitats_referral_agent_office.present? && citi_habitats_referral_agent_amount.present?) ||
    (corcoran_referral_agent? && corcoran_referral_agent_name.present? && corcoran_referral_agent_office.present? && corcoran_referral_agent_amount.present?) ||
    (outside_agency? && outside_agency_name.present? && outside_agency_amount.present?) ||
    (relocation_referral? && relocation_referral_name.present? && relocation_referral_amount.present?) ||
    (listing_fee? && listing_fee_name.present? && listing_fee_office.present? && listing_fee_percentage.present?)
  end
  
  def referred_title
    "referral source"
  end
  
  def cut?
    commission_fee_percentage.present? && deal&.staffed? && (co_broke? ? co_broke_commission.present? : true) && (referral? ? referral_payment.present? : true)
  end
  
  def cut_title
    "commission fee %, deal assists, co-broke and referral payment amounts if applicable"
  end
  
  def dated?
    lease_sign_date.present? && approval_date.present? && request_date.present?
  end
  
  def dated_title
    "lease sign date, approval date, request date"
  end
  
  def co_broke?
    co_exclusive_agency? || exclusive_agent? || exclusive_agency?
  end
  
  def referral?
    citi_habitats_referral_agent? || corcoran_referral_agent? || outside_agency? || relocation_referral?
  end
  
  def Commission.document_roles
    [
      'Listing (from LEAR)',
      'Lease (First Page and Signature Page)',
      'NY State Agency Disclosure',
      'Proof of Commission Payment',
      'Exclusive Agreement with Landlord',
      'Owner Pay Invoice',
      'Other'
    ]
  end
  
  def required_document_roles
    requirements = [
      'Listing (from LEAR)',
      'Lease (First Page and Signature Page)',
      'NY State Agency Disclosure',
      'Proof of Commission Payment'
    ]
    requirements << 'Owner Pay Invoice' if owner_pay_commission > 0
    requirements
  end
  
  def missing_documentation
    required_document_roles - documents.map(&:role)
  end
  
  def documentation_status
    if missing_documentation.present?
      missing_documentation.to_sentence.chomp + ' still needed.'
    else
      'Required documentation present.'
    end
  end
  
  def documented?
    documentation_status == 'Required documentation present.'
  end
  
  def documented_commission
    documents.commission_payments.inject(0) { |sum, payment| sum + BigDecimal(sprintf '%.2f', eval(payment.name)) rescue nil if payment.name =~ /[\d\s\+\.]+/ }
  end
end
