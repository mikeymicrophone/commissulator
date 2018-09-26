Fabricator :tenant do
  lease { find_or_fabricate :lease }
  client { find_or_fabricate :client }
end
