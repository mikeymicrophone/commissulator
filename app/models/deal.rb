class Deal < ApplicationRecord
  belongs_to :agent
  has_many :assists, :dependent => :destroy
  has_many :agents, :through => :assists
  belongs_to :package
  has_one :commission
  has_many :documents
  delegate :annualized_rent, :agent_split_percentage, :citi_commission, :owner_pay_commission, :tenant_side_commission, :listing_side_commission, :total_commission, :co_broke_commission, :to => :commission, :allow_nil => true
  
  enum :status => [:preliminary, :underway, :submitted, :approved, :accepted, :rejected, :withdrawn, :cancelled, :closed]
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
    inbound_commission
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
    listing_fee.to_d + commission&.citi_habitats_referral_agent_amount.to_d + commission&.corcoran_referral_agent_amount.to_d + commission&.outside_agency_amount.to_d + commission&.relocation_referral_amount.to_d
  end
  
  def listing_fee
    (commission.listing_fee_percentage / BigDecimal(100)) * inbound_commission if commission&.listing_fee?
  end
  
  def staffed?
    assists.leading.present? && assists.interviewing.present? && assists.showing.present? && assists.closing.present?
  end
  
  def special_efforts
    assists.group_by(&:agent_id).select do |agent_id, assists|
      assists.reject(&:new_record?).inject(0) { |sum, assist| sum + assist.role_rate } > 0.45
    end
  end
  
  def special_payments
    special_efforts.map do |agent_id, assists|
      agent = Agent.find agent_id
      if agents.map(&:name).append(agent.name).include? agent.distinct_payable_name
        "Override payment from #{agent.payable_name} to #{agent.name}: #{number_to_currency 10.percent_of remaining_commission}"
      end
    end
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
