include ActionView::Helpers::NumberHelper
Tenant = Struct.new :name, :email, :phone

class Commission < ApplicationRecord
  belongs_to :deal, :optional => true
  belongs_to :agent, :optional => true
  belongs_to :landlord, :optional => true
  has_many :documents, :through => :deal
  serialize :tenant_name
  serialize :tenant_email
  serialize :tenant_phone_number
  attr_default :tenant_name, []
  attr_default :tenant_email, []
  attr_default :tenant_phone_number, []
  attr_default :branch_name, 'Park Avenue South'
  attr_default :agent_name, 'Desmond Eaddy'
  # attr_default :agent_split_percentage, '70'
  attr_default :copy_of_lease, true
  attr_default :lease_start_date, lambda { Date.civil Date.today.next_month.year, Date.today.next_month.month, 1 }
  attr_default :lease_term, '12 months'
  # attr_default :owner_pay_commission, 0
  # attr_default :listing_side_commission, 0
  attr_default :reason_for_fee_reduction, 'N/A'
  
  before_save :trim_tenants
  before_create :meet_landlord, :name_agent
  after_save :address_deal
  
  enum :follow_up => [:unsubmitted, :submitted]
  attr_default :follow_up, :unsubmitted
  
  acts_as_paranoid
  
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
  
  def tenants
    group = []
    tenant_name.each_with_index do |name, index|
      tenant = Tenant.new name, tenant_email[index], tenant_phone_number[index]
      group << tenant
    end
    group
  end
  
  def fub_people
    people = []
    tenants.each do |tenant|
      first_name = tenant.name.split.first
      last_name = tenant.name.split[1..-1].join ' '
      person = FubClient::Person.new :firstName => first_name, :lastName => last_name, :emails => [{:value => tenant.email}], :phones => [{:value => tenant.phone}]
      people << person
    end
    people
  end
  
  def follow_up!
    fub_people.each do |person|
      begin
        person.save
      rescue NoMethodError => error
        Rails.logger.debug error.inspect
      end
    end
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
    requirements << 'Exclusive Agreement with Landlord' if co_exclusive_agency? || exclusive_agency? || exclusive_agent?
  end
  
  def missing_documentation
    required_document_roles - documents.map(&:role)
  end
  
  def documentation_status
    if missing_documentation.present?
      missing_documentation.to_sentence.chomp + ' still needed.'
    else
      "Required documentation present."
    end
  end
  
  def documented_commission
    documents.commission_payments.inject(0) { |sum, payment| sum + BigDecimal(eval(payment.name)) if payment.name =~ /[\d\s\+\.]+/ }
  end
end
