class Tenant < ApplicationRecord
  belongs_to :client
  belongs_to :lease
  validates_associated :lease
  validates_associated :client
end
