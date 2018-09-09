include ActionView::Helpers::NumberHelper
class Employment < ApplicationRecord
  belongs_to :client
  belongs_to :employer
  validates_associated :employer
  
  def phones
    Phone.where :client => client, :employer => employer
  end
  
  def emails
    Email.where :client => client, :employer => employer
  end
  
  def social_accounts
    SocialAccount.where :client => client, :employer => employer
  end
  
  def contacts
    phones + emails + social_accounts
  end
  
  def name
    info = client.name
    info += " as #{position}" if position.present?
    info += " at #{employer.name}"
    info += " making #{number_to_currency income}" if income.present?
    info += " since #{start_date.to_s}" if start_date.present?
    info
  end
end
