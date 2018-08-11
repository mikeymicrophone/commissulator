Fabricator :assistant do
  first_name { Faker::Name.first_name }
  last_name { Faker::Name.last_name }
  phone_number { Faker::PhoneNumber.phone_number }
  email { |attrs| Faker::Internet.email "#{attrs[:first_name]} #{attrs[:last_name]}" }
  status { :active }
end
