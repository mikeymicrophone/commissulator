Fabricator :commission do
  request_date { Date.today }
  lease_sign_date { Date.yesterday }
  approval_date { Date.today }
  
  deal { Fabricate :completed_deal }
  agent { |attrs| attrs[:deal].agent }
  landlord { find_or_fabricate :landlord }
  landlord_name { |attrs| attrs[:landlord].name }
  landlord_email { |attrs| attrs[:landlord].email }
  landlord_phone_number { |attrs| attrs[:landlord].phone_number }
  agent_name { |attrs| attrs[:agent].name }
  # agent_split_percentage { 70 }
  
  bedrooms { (2..8).to_a.sample / 2.0 }
  property_type { ['Condo', 'Rental', 'Co-op', 'Rental', 'Loft', 'Rental', 'Townhouse', 'Rental', 'Walk-up', 'Rental', 'Brownstone', 'Rental', 'Condop', 'Rental', 'Green', 'Rental'].sample }
  new_development { true if die_roll(7) }
  lease_start_date { Date.civil(Date.today.year, Date.today.month + rand(3), 1) }
  lease_term { |attrs| [12, 12, 12, 16, 18, 24].sample.to_s + ' months' }
  square_footage { 300 + rand(2000) }
  listed_monthly_rent { |attrs| attrs[:square_footage] * 3 + rand(1300) }
  landlord_source { find_or_fabricate(:agent).name }
  tenant_source { find_or_fabricate(:agent).name }

  copy_of_lease { true }
  property_address { Faker::Address.street_address }
  apartment_number { (1..25).to_a.sample.to_s + (?A..?L).to_a.sample }
  zip_code { '1000' + rand(280).to_s }
  leased_monthly_rent { |attrs| die_roll(4) ? attrs[:listed_monthly_rent] - rand(10) * 20 : attrs[:listed_monthly_rent] }
  annualized_rent { |attrs| attrs[:leased_monthly_rent] * 12 }
  transient :fee
  fee { |attrs| (12..25).to_a.sample.percent_of attrs[:annualized_rent] }
  
  transient :owner_pay
  owner_pay { die_roll 5 }
  owner_pay_commission { |attrs| attrs[:owner_pay] ? attrs[:leased_monthly_rent] : 0 }
  listing_side_commission { |attrs| die_roll(10) ? attrs[:fee] / 2.0 : 0 }
  tenant_side_commission { |attrs| attrs[:fee] - attrs[:listing_side_commission] }
  
  total_commission { |attrs| attrs[:owner_pay_commission] + attrs[:tenant_side_commission] + attrs[:listing_side_commission] }
  commission_fee_percentage { |attrs| (attrs[:total_commission] / attrs[:annualized_rent]) * 100 }
  transient :co_broke
  co_broke { die_roll(2) }
  
  co_broke_commission { |attrs| attrs[:co_broke] ? attrs[:total_commission] * 0.5 : 0 }
  citi_commission { |attrs| attrs[:total_commission] - attrs[:co_broke_commission] }
  
  open_listing { |attrs| !attrs[:co_broke] }
  
  # intranet_deal_number { rand(342342423) }
  before_validation { |commission, transients| add_tenants_to commission }
end

Fabricator :co_exclusive_commission, :from => :commission do
  co_exclusive_agency true
  citi_habitats_agent true
  co_exclusive_agency_name { Faker::Company.name }
  citi_habitats_agent_name { Faker::Name.name }
  citi_habitats_agent_office { Faker::Address.street_name }
  co_broke false
  # listing side?
end

Fabricator :exclusive_agency_commission, :from => :commission do
  exclusive_agency true
  corcoran_agent true
  exclusive_agency_name { Faker::Company.name }
  corcoran_agent_name { Faker::Name.name }
  corcoran_agent_office { Faker::Address.street_name }
  co_broke true
end

Fabricator :exclusive_agent_commission, :from => :commission do
  exclusive_agent true
  co_broke_company true
  exclusive_agent_name { Faker::Name.name }
  co_broke_company_name { Faker::Company.name }
  exclusive_agent_office { Faker::Address.street_name }
  co_broke true
end

Fabricator :referral_commission, :from => :commission do
  citi_habitats_referral_agent true
  citi_habitats_referral_agent_name { Faker::Name.name }
  citi_habitats_referral_agent_office { Faker::Address.street_name }
  citi_habitats_referral_agent_amount { (3..8).to_a.sample * 100 }
  referral_payment { |attrs| attrs[:citi_habitats_referral_agent_amount] }
  
  citi_commission { |attrs| attrs[:co_broke] ? attrs[:total_commission].to_d * 0.5 - attrs[:referral_payment].to_d : attrs[:total_commission].to_d - attrs[:referral_payment].to_d }
end

def add_tenants_to commission
  (1..5).to_a.sample.times do
    name = Faker::Name.name
    commission.tenant_name << name
    commission.tenant_email << Faker::Internet.email(name)
    commission.tenant_phone_number << Faker::PhoneNumber.phone_number
  end
end
