class Registrant < ApplicationRecord
  belongs_to :client
  belongs_to :registration
  
  def name
    "#{client.name} in #{registration.name}"
  end
end
