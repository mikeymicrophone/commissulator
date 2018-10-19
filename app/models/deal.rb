include CommissionsHelper
class Deal < ApplicationRecord
  belongs_to :agent
  has_many :assists, :dependent => :destroy
  has_many :agents, -> { distinct }, :through => :assists
  belongs_to :package, :optional => true
  has_one :commission
  has_one :landlord, :through => :commission
  has_one :lease, :through => :commission
  has_many :clients, :through => :lease
  has_many :documents
  delegate :fub_people, :annualized_rent, :agent_split_percentage, :citi_commission, :owner_pay_commission, :tenant_side_commission, :listing_side_commission, :total_commission,
           :co_broke_commission, :citi_habitats_referral_agent_amount, :corcoran_referral_agent_amount, :outside_agency_amount, :relocation_referral_amount, :lease_end_date,
           :lease_sign_date, :lease_start_date, :lease_term, :leased_monthly_rent, :property_address, :apartment_number, :to => :commission, :allow_nil => true
  
  enum :status => [:preliminary, :underway, :submitted, :approved, :accepted, :rejected, :withdrawn, :cancelled, :closed, :commission_requested, :commission_processed]
  attr_default :status, :preliminary
  
  scope :this_week, -> { where Deal.arel_table[:created_at].gt 1.week.ago }

  def reference
    if name.present?
      name
    else
      "#{address} #{unit_number}"
    end
  end
  
  def subcommissions
    package = Hash.new 0
    assists.each do |assist|
      package[assist.agent.payable_name] += assist.payout
    end
    
    package[agent.name] += agent_commission
    package
  end
  
  def inbound_commission
    citi_commission.to_d - listing_side_commission.to_d
  end
  
  def remaining_commission
    inbound_commission - internal_referral
  end
  
  def closeout
    agent_split_percentage.percent_of remaining_commission
  end
  
  def house_cut
    remaining_commission * (1 - (agent_split_percentage.to_d / BigDecimal(100)))
  end
  
  def agent_commission
    remaining_commission * (agent_split_percentage.to_d / BigDecimal(100)) - distributed_commission
  end
  
  def company_commission
    20.percent_of(remaining_commission) - special_payments_total rescue nil
  end
  
  def payout_to assisting_agent
    assists.where(:agent => assisting_agent).sum &:payout if commission
  end
  
  def roles_for assisting_agent
    assists.where(:agent => assisting_agent).map(&:name).to_sentence
  end
  
  def distributable_commission participation_rate
    participation_rate.percent_of(remaining_commission - expenses)
  end
  
  def distributed_commission
    assists.inject(0) { |sum, assist| sum + assist.payout.to_d }
  end
  
  def expenses
    assists.sum :expense
  end
  
  def referral_payment
    listing_fee.to_d + citi_habitats_referral_agent_amount.to_d + corcoran_referral_agent_amount.to_d + outside_agency_amount.to_d + relocation_referral_amount.to_d
  end
  
  def external_referral
    corcoran_referral_agent_amount.to_d + outside_agency_amount.to_d + relocation_referral_amount.to_d
  end
  
  def internal_referral
    listing_fee.to_d + citi_habitats_referral_agent_amount.to_d
  end
  
  def listing_fee
    (commission.listing_fee_percentage / BigDecimal(100)) * inbound_commission if commission&.listing_fee?
  end
  
  def staffed?
    assists.leading.present? && assists.interviewing.present? && assists.showing.present? && assists.closing.present?
  end
  
  def unit_type
    case commission.bedrooms
    when 0
      'Studio'
    else
      "#{rounded commission.bedrooms} Bedroom"
    end
  end
  
  def fub_deal
    @fub_deal ||= FubClient::Deal.find(follow_up_boss_id) || fub_create
  end
  
  def fub_create
    fub_object = FubClient::Deal.new(:name => "#{property_address} ##{apartment_number}", :stageId => ENV['FOLLOW_UP_BOSS_STAGE_ID_CLOSED'],
      :price => leased_monthly_rent, :commissionValue => total_commission, :projectedCloseDate => lease_sign_date, :description => fub_description,
      :peopleIds => fub_people.map(&:id).append(landlord.follow_up_boss_id), :userIds => agents.map(&:follow_up_boss_id))
    begin
      fub_object.save
    rescue NoMethodError => error
      Rails.logger.debug error.inspect
    end
    update_attribute :follow_up_boss_id, fub_object.id
    fub_object
  end
  
  def fub_annotate_people
    clients.each do |client|
      fub_note = FubClient::Note.new :subject => 'Closing', :body => 'We rented them an apartment.', :personId => client.follow_up_boss_id
      begin
        fub_note.save
      rescue NoMethodError => error
        Rails.logger.debug error.inspect
      end
    end
  end
  
  def fub_description with_roles = ''
    <<~DESCRIBE
    #{clients.map(&:name).to_sentence}
    Address: #{address} ##{unit_number}
    Apt Type: #{unit_type}
    Lease Start: #{lease_start_date.strftime("%b ") + lease_start_date.day.ordinalize + ", " + lease_start_date.year.to_s}
    Lease Term: #{lease_term}
    Rent: #{rounded leased_monthly_rent}
    Commission: #{rounded total_commission}#{owner_pay_commission.present? ? "\nOwner Pay Commission: #{rounded owner_pay_commission}" : ''}
    Landlord: #{landlord.name}
    #{with_roles}
    DESCRIBE
  end
  
  def special_efforts
    assists.group_by(&:agent_id).select do |agent_id, assists|
      assists.reject(&:new_record?).inject(0) { |sum, assist| sum + assist.role_rate } > 0.45
    end
  end
  
  def special_payments
    special_efforts.map do |agent_id, assists|
      assisting_agent = Agent.find agent_id
      if agents.map(&:name).append(agent.name).include? assisting_agent.distinct_payable_name
        "Override payment from #{assisting_agent.payable_name} to #{assisting_agent.name}: #{number_to_currency 10.percent_of remaining_commission}"
      end
    end
  end
  
  def special_payments_total
    special_payments.compact.count * 10.percent_of(remaining_commission)
  end
  
  def rate_for role
    send "#{role}_rate"
  end
  
  def lead_rate
    0.20
  end
  
  def interview_rate
    0.25
  end
  
  def show_rate
    0.30
  end
  
  def close_rate
    0.25
  end
  
  def custom_rate
    0
  end
end
