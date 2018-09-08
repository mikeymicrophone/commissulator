class Registrant < ApplicationRecord
  belongs_to :client
  belongs_to :registration
end
