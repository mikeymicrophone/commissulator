Fabricator :assist do
  deal { Fabricate :deal }
  agent
  role { Assist.roles.keys.sample }
  status :active
end
