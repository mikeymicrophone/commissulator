class Assist < ApplicationRecord
  belongs_to :deal
  belongs_to :agent
  has_one :commission, :through => :deal
  enum :role => [:lead, :interview, :show, :close, :custom]
  enum :status => [:preliminary, :active, :removed]
  attr_default :rate, 50
  
  before_create :infer_rate
  
  scope :leading, lambda { where :role => :lead }
  scope :interviewing, lambda { where :role => :interview }
  scope :showing, lambda { where :role => :show }
  scope :closing, lambda { where :role => :close }
  scope :chrono, lambda { order :role }
  
  def name
    "#{role} by #{agent.name}"
  end
  
  def payout
    role_rate * deal.distributable_commission(rate) / deal.assists.where(:role => role).count + adjustment.to_d + expense.to_d if deal.commission
  end
  
  def role_rate
    deal.rate_for role
  end
  
  def infer_rate
    self.rate = agent.rate if agent.rate.present?
  end
end
