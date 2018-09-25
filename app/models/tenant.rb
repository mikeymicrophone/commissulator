class Tenant < ApplicationRecord
  belongs_to :client
  belongs_to :lease
end
