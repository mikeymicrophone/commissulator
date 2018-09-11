class Assist < ApplicationRecord
  belongs_to :deal
  belongs_to :agent
  belongs_to :role
  has_one :commission, :through => :deal
  # enum :role => [:lead, :interview, :show, :close, :custom]
  enum :status => [:preliminary, :active, :removed]
  attr_default :rate, 50
  
  before_create :infer_rate
  
  scope :leading, lambda { where :role_id => Role.where(:name => 'lead').take }
  scope :interviewing, lambda { where :role_id => Role.where(:name => 'interview').take }
  scope :showing, lambda { where :role_id => Role.where(:name => 'show').take }
  scope :closing, lambda { where :role_id => Role.where(:name => 'close').take }
  scope :chrono, lambda { order :role_id }
  
  def name
    "#{role} by #{agent.name}"
  end
  
  def payout
    role_rate * deal.distributable_commission(rate) / deal.assists.where(:role => role).count + adjustment.to_d + expense.to_d if deal.commission
  end
  
  def role_rate
    role.rate.percent * 2
  end
  
  def infer_rate
    self.rate = agent.rate if agent.rate.present?
  end
end
