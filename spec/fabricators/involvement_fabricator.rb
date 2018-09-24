Fabricator :involvement do
  package { Fabricate :package }
  role { Fabricate :role }
  rate { rand(100).percent }
  description { Faker::Hipster.sentence }
end
