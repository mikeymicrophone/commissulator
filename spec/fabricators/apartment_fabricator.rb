Fabricator :apartment do
  unit_number { Faker::Address.secondary_address }
  street_number { Faker::Address.building_number }
  street_name { Faker::Address.street_name }
  zip_code { Faker::Address.zip_code }
  size { Registration::APARTMENT_SIZES.sample }
  rent { (20..90).to_a.sample * 50 }
  comment { Faker::Hipster.sentence }
  registration { find_or_fabricate :registration }
end
