Fabricator :client do
  first_name { Faker::Name.first_name }
  last_name { Faker::Name.last_name }
  date_of_birth { (18*365..50*365).to_a.sample.days.ago }
end
