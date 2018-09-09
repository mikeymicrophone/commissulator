class Apartment < ApplicationRecord
  belongs_to :registration
  
  def name
    "#{unit_number} #{street_number} #{street_name} [#{ApplicationController.helpers.number_to_round_currency rent} #{size}]"
  end
end
