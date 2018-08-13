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
  attr_default :agent_split_percentage, '70'
  attr_default :copy_of_lease, true
  attr_default :lease_start_date, lambda { Date.civil Date.today.next_month.year, Date.today.next_month.month, 1 }
  attr_default :lease_term_date, lambda { (Date.today + 1.year).end_of_month }
  
  def subcommission_payout_summary
    deal.subcommissions.inject('') { |summary, award| summary + "#{award.first}: #{number_to_currency award.last}   " }
  end
end
