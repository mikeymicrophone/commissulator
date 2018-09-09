include ActionView::Helpers::NumberHelper
class Apartment < ApplicationRecord
  belongs_to :registration
  
  def name
    "#{unit_number} #{street_number} #{street_name} [#{number_to_currency rent} #{size}]"
  end
end
