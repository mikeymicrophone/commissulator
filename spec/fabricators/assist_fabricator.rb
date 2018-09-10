Fabricator :assist do
  deal { find_or_fabricate :deal }
  agent { find_or_fabricate :agent }
  role { Assist.roles.keys.sample }
  status :active
end
