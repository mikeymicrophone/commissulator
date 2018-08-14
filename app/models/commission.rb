include ActionView::Helpers::NumberHelper
class Commission < ApplicationRecord
  belongs_to :deal, :optional => true
  belongs_to :agent, :optional => true
  belongs_to :landlord, :optional => true
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
  attr_default :lease_term_date, lambda { (Date.today + 1.year).end_of_month }
  attr_default :owner_pay_commission, 0
  attr_default :listing_side_commission, 0
  
  before_save :trim_tenants
  before_create :meet_landlord
  
  def subcommission_payout_summary
    deal.subcommissions.inject('') { |summary, award| summary + "#{award.first}: #{number_to_currency award.last}   " }
  end
  
  def trim_tenants
    self.tenant_name.reject! &:blank?
    self.tenant_email.reject! &:blank?
    self.tenant_phone_number.reject! &:blank?
  end
  
  def meet_landlord
    self.landlord = Landlord.where(:name => landlord_name).take || Landlord.where(:name => landlord_name, :email => landlord_email, :phone_number => landlord_phone_number).create
  end
  
  def boolean_display attribute
    'X' if attribute # '✓' if attribute
  end
end
