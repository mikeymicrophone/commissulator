class Deal < ApplicationRecord
  belongs_to :agent
  has_many :participants
  has_one :commission
  delegate :annualized_rent, :owner_pay_commission, :tenant_side_commission, :listing_side_commission, :total_commission, :co_broke_commission, :to => :commission
  
  enum :status => [:preliminary, :underway, :submitted, :approved, :accepted, :rejected, :withdrawn, :cancelled, :closed]
  attr_default :status, :preliminary

  def reference
    if name.present?
      name
    else
      "#{address} #{unit_number}"
    end
  end
  
  def subcommissions
    package = Hash.new 0
    participants.leading.each do |participant|
      package[participant.assistant.name] += lead_commission / participants.leading.count
    end
    
    participants.interviewing.each do |participant|
      package[participant.assistant.name] += interview_commission / participants.interviewing.count
    end
    
    participants.showing.each do |participant|
      package[participant.assistant.name] += show_commission / participants.showing.count
    end
    
    participants.closing.each do |participant|
      package[participant.assistant.name] += close_commission / participants.closing.count
    end
    package
  end
  
  def inbound_commission
    commission&.citi_commission.to_d
  end
  
  def house_cut
    (inbound_commission - referral_payment) * (1 - (commission.agent_split_percentage / BigDecimal(100)))
  end
  
  def agent_commission
    (inbound_commission - referral_payment) * (commission.agent_split_percentage / BigDecimal(100)) - distributable_commission
  end
  
  def distributable_commission
    (inbound_commission - referral_payment) * 0.5
  end
  
  def referral_payment
    listing_fee.to_d + commission.citi_habitats_referral_agent_amount.to_d + commission.corcoran_referral_agent_amount.to_d + commission.outside_agency_amount.to_d + commission.relocation_referral_amount.to_d
  end
  
  def listing_fee
    (commission.listing_fee_percentage / BigDecimal(100)) *  inbound_commission if commission&.listing_fee?
  end
  
  def lead_commission
    lead_rate * distributable_commission
  end
  
  def interview_commission
    interview_rate * distributable_commission
  end
  
  def show_commission
    show_rate * distributable_commission
  end
  
  def close_commission
    close_rate * distributable_commission
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
end
