Fabricator :avatar do
  first_name { Faker::Name.first_name }
  last_name { Faker::Name.last_name }
  email { |attrs| Faker::Internet.email "#{attrs[:first_name]} #{attrs[:last_name]}" }
  password { Faker::Internet.password }
  phone_number { Faker::PhoneNumber.phone_number }
  
  after_create { |avatar, transients| avatar.confirm }
end
