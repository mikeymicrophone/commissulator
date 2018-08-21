Fabricator :participant do
  deal { find_or_fabricate :deal }
  assistant { find_or_fabricate :assistant }
  role { Participant.roles.keys.sample }
  status :active
end
