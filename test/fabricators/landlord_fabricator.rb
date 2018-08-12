Fabricator :landlord do
  name { Faker::Name.name }
  email { |attrs| Faker::Internet.email attrs[:name]}
  phone_number { Faker::PhoneNumber.phone_number }
end
