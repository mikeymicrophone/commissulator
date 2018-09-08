module RegistrationsHelper
  def price_range_options
    prices = (2..30).to_a.map { |num| num * 500 }.append(1250, 1750, 2250).sort
    options_for_select prices
  end
  
  def size_options
    apartment_sizes = ['Alcove Studio', 'Junior-1', 'Studio', 'One Bedroom', 'Junior-4', 'Convertible-2', 'Two Bedroom', 'Convertible-3', 'Classic-6', 'Three Bedroom', 'Classic-7', 'Convertible-4', 'Four Bedroom', 'Five Bedroom+']
    options_for_select apartment_sizes
  end
end
