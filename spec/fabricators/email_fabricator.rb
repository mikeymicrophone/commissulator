Fabricator :email do
  client { find_or_fabricate :client }
  employer { find_or_fabricate :employer if die_roll(5) }
  number { Faker::Internet.email }
  variety { Email::VARIETIES.sample }
end

Fabricator :work_email, :from => :email do
  client { nil }
  employer { find_or_fabricate :employer }
  variety { ['work', 'office'].sample }
end
