module RegistrationsHelper
  def price_range_options
    options_for_select Registration::PRICES
  end
  
  def size_options
    options_for_select Registration::APARTMENT_SIZES
  end
end
