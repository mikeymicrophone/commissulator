Fabricator :role do
  name { Faker::GreekPhilosophers.name }
  rate { rand(100).percent }
  active { true }
end
