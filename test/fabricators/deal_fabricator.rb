Fabricator :deal do
  address { Faker::Address.street_address }
  unit_number { (1..25).to_a.sample.to_s + (?A..?L).to_a.sample }
  commission { 50 * rand(700) + 400 }
  agent { find_or_fabricate :agent }
end

Fabricator :completed_deal, :from => :deal do
  after_create { |deal, transients| full_participation_in deal }
end

def full_participation_in deal
  Fabricate :participant, :deal => deal, :role => :lead
  Fabricate :participant, :deal => deal, :role => :interview
  Fabricate :participant, :deal => deal, :role => :interview if die_roll(10)
  Fabricate :participant, :deal => deal, :role => :show
  Fabricate :participant, :deal => deal, :role => :show if die_roll(4)
  Fabricate :participant, :deal => deal, :role => :close
end
