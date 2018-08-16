class Deal < ApplicationRecord
  belongs_to :agent
  has_many :participants
  has_one :commission
  
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
  
  def distributable_commission
    (commission&.total_commission.to_f - referral_payment) * 0.5
  end
  
  def referral_payment
    commission.citi_habitats_referral_agent_amount.to_f + commission.corcoran_referral_agent_amount.to_f + commission.outside_agency_amount.to_f + commission.relocation_referral_amount.to_f
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
