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
end
