Fabricator :employment do
  client { find_or_fabricate :client }
  employer { find_or_fabricate :employer }
  position { Faker::Job.position }
  income { (1600..10000).to_a.sample * 50 }
  start_date { (1..5000).to_a.sample.days.ago if die_roll(2) }
end
