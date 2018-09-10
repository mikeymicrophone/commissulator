Fabricator :deal do
  address { Faker::Address.street_address }
  unit_number { (1..25).to_a.sample.to_s + (?A..?L).to_a.sample }
  agent { find_or_fabricate :agent }
end

Fabricator :underway_deal, :from => :deal do
  status :underway
  after_create { |deal, transients| partial_participation_in deal }
end

Fabricator :completed_deal, :from => :deal do
  status :accepted
  after_create { |deal, transients| full_participation_in deal }
end

def partial_participation_in deal
  Fabricate :assist, :deal => deal, :role => :lead
  if die_roll(2)
    Fabricate :assist, :deal => deal, :role => :interview
    Fabricate :assist, :deal => deal, :role => :interview if die_roll(10)
    
    if die_roll(3)
      Fabricate :assist, :deal => deal, :role => :show
      Fabricate :assist, :deal => deal, :role => :show if die_roll(4)
      
      if die_roll
        Fabricate :assist, :deal => deal, :role => :close
        deal.update_attribute :status, :submitted
      end
    end
  end
end

def full_participation_in deal
  Fabricate :assist, :deal => deal, :role => :lead
  Fabricate :assist, :deal => deal, :role => :interview
  Fabricate :assist, :deal => deal, :role => :interview if die_roll(10)
  Fabricate :assist, :deal => deal, :role => :show
  Fabricate :assist, :deal => deal, :role => :show if die_roll(4)
  Fabricate :assist, :deal => deal, :role => :close
end
