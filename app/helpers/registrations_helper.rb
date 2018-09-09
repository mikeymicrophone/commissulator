module RegistrationsHelper
  def price_range_options
    options_for_select Registration::PRICES
  end
  
  def size_options
    options_for_select Registration::APARTMENT_SIZES
  end
  
  def fabricate_registration_link
    link_to 'Fabricate Registration', fabricate_registrations_path, :method => :post unless Rails.env.production?
  end
end
