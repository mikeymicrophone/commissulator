Fabricator :agent do
  first_name { Faker::Name.first_name }
  last_name { Faker::Name.last_name }
  email { Faker::Internet.email }
  password { Faker::Internet.password }
  phone_number { Faker::PhoneNumber.phone_number }
  
  after_create { |agent, transients| agent.confirm }
end
