Fabricator :assist do
  deal { find_or_fabricate :deal }
  assistant { find_or_fabricate :assistant }
  role { Assist.roles.keys.sample }
  status :active
end
