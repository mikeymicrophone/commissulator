Fabricator :employer do
  name { Faker::Company.name }
  address { Faker::Address.full_address }
  url { Faker::Internet.url }
end
