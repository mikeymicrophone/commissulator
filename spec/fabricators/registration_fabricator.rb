Fabricator :registration do
  minimum_price { Registration::PRICES.sample }
  maximum_price { |attrs| Registration::PRICES.select { |price| price > attrs[:minimum_price]}.sample }
  size { Registration::APARTMENT_SIZES.sample }
  move_by { (1..100).to_a.sample.days.from_now }
  reason_for_moving { ['space', 'location', 'renovation', 'roommates'].sample }
  occupants { occs = []; (1..6).to_a.each { |num| num.times { occs << (7 - num) } }; occs.sample }
  pets { pet_text if die_roll }
  referral_source { find_or_fabricate :referral_source }
  agent { find_or_fabricate :agent }
end

def pet_text
  text = ''
  [1, 1, 1, 2, 2, 3].sample.times do
    species = die_roll(2) ? :dog : :cat
    breed = (species == :dog) ? Faker::Dog.breed : Faker::Cat.breed
    weight = (species == :dog) ? (5..130).to_a.sample : (4..28).to_a.sample
    text += "#{weight} lb #{breed} #{species} "
  end
  text.chomp
end

Fabricator :complete_registration, :from => :registration do
  after_create { |registration, transients| qualify_and_locate registration }
  after_create { |registration, transients| apartments_considered_by registration }
  after_create { |registration, transients| roommates_added_by registration }
end

def qualify_and_locate registration
  client = find_or_fabricate :client
  registrant = find_or_fabricate :registrant, :client => client, :registration => registration
  employer = find_or_fabricate :employer
  employment = Fabricate :employment, :client => client, :employer => employer
  niche = find_or_fabricate :niche, :employer => employer
  landlord = find_or_fabricate :landlord
  lease = Fabricate :lease, :client => client, :registration => registration, :landlord => landlord
  home_phone = Fabricate :phone, :client => client
  cell_phone = Fabricate :cell_phone, :client => client
  email = Fabricate :email, :client => client
  work_phone = Fabricate :work_phone, :client => client, :employer => employer
end

def apartments_considered_by registration
  (1..5).to_a.sample.times do
    Fabricate :apartment, :registration => registration
  end
end

def roommates_added_by registration
  (0..4).to_a.sample.times do
    roommate_in registration
  end
end

def roommate_in registration
  client = Fabricate :client
  registrant = Fabricate :registrant, :client => client, :registration => registration
  employer = find_or_fabricate :employer
  employment = Fabricate :employment, :client => client, :employer => employer
  phone = Fabricate :cell_phone, :client => client
end
