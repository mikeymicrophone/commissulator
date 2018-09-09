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
