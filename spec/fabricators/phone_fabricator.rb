Fabricator :phone do
  client { find_or_fabricate :client }
  employer { find_or_fabricate :employer if die_roll(5) }
  number { Faker::PhoneNumber.phone_number }
  variety { Phone::VARIETIES.sample }
end

Fabricator :cell_phone, :from => :phone do
  number { Faker::PhoneNumber.cell_phone }
  variety 'cell'
end

Fabricator :work_phone, :from => :phone do
  client { nil }
  employer { find_or_fabricate :employer }
  variety { ['work', 'office'].sample }
end
