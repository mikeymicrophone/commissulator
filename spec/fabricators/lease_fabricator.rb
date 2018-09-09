Fabricator :lease do
  apartment_number { Faker::Address.secondary_address }
  street_number { Faker::Address.building_number }
  street_name { Faker::Address.street_name }
  zip_code { Faker::Address.zip_code }
  landlord { find_or_fabricate :landlord }
  client { find_or_fabricate :client }
  registration { find_or_fabricate :registration }
end
