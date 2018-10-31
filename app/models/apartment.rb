class Apartment < ApplicationRecord
  include Sluggable

  belongs_to :registration

  def to_param
    basic_slug([id, street_number, street_name, unit_number, zip_code])
  end
  
  def name
    "#{unit_number} #{street_number} #{street_name} [#{ApplicationController.helpers.number_to_round_currency rent} #{size}]"
  end
end
