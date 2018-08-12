Fabricator :commission do
  deal { find_or_fabricate :deal }
  agent { |attrs| attrs[:deal].agent }
  landlord { find_or_fabricate :landlord }
  branch_name { 'Park Avenue South' }
  tenant_name { [Faker::Name.name] }
  tenant_email { [Faker::Internet.email] }
  tenant_phone_number { [Faker::PhoneNumber.phone_number] }
  landlord_name { |attrs| attrs[:landlord].name }
  landlord_email { |attrs| attrs[:landlord].email }
  landlord_phone_number { |attrs| attrs[:landlord].phone_number }
  agent_name { |attrs| attrs[:agent].name }
  bedrooms { (2..8).to_a.sample / 2.0 }
  property_type { ['Condo', 'Rental', 'Co-op', 'Rental', 'Loft', 'Rental', 'Townhouse', 'Rental', 'Walk-up', 'Rental', 'Brownstone', 'Rental', 'Condop', 'Rental', 'Green', 'Rental'].sample }
  new_development { true if die_roll(7) }
  lease_start_date { Date.civil(Date.today.year, Date.today.month + rand(3), 1) }
  lease_term_date { |attrs| attrs[:lease_start_date] + [12, 12, 12, 16, 18, 24].sample.months }
  square_footage { 300 + rand(2000) }
  listed_monthly_rent { |attrs| attrs[:square_footage] * 3 + rand(1300) }
  landlord_source { find_or_fabricate(:assistant).name }
  tenant_source { find_or_fabricate(:assistant).name }
  # intranet_deal_number { rand(342342423) }
  copy_of_lease { true if die_roll(3) }
  property_address { Faker::Address.street_address }
  apartment_number { (1..25).to_a.sample.to_s + (?A..?L).to_a.sample }
  zip_code { '1000' + rand(9).to_s }
  lease_sign_date { Date.yesterday }
  approval_date { Date.today }
  leased_monthly_rent { |attrs| die_roll(4) ? attrs[:listed_monthly_rent] - rand(10) * 20 : attrs[:listed_monthly_rent] }
  annualized_rent { |attrs| attrs[:leased_monthly_rent] * 12 }
  commission_fee_percentage { (10..36).to_a.sample / 2.0 }
  agent_split_percentage { 70 }
  owner_pay_commission { |attrs| die_roll(5) ? attrs[:leased_monthly_rent] : 0 }
  listing_side_commission { |attrs| die_roll(10) ? attrs[:owner_pay_commission] / 2.0 : 0 }
  tenant_side_commission { |attrs| attrs[:annualized_rent] * (attrs[:commission_fee_percentage] / 100.0) }
  reason_for_fee_reduction { '' }
  request_date { Date.today }
  total_commission { |attrs| attrs[:owner_pay_commission] + attrs[:tenant_side_commission] }
  citi_commission { |attrs| attrs[:total_commission] * 0.3 }
  co_broke_commission { |attrs| attrs[:total_commission] * 0.2 }
end
