class Commission < ApplicationRecord
  belongs_to :deal
  belongs_to :agent
  belongs_to :landlord
  serialize :tenant_name
  serialize :tenant_email
  serialize :tenant_phone_number
end
