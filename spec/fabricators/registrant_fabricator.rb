Fabricator :registrant do
  client
  registration { find_or_fabricate :registration }
  other_fund_sources { fund_sources.sample if die_roll }
end

def fund_sources
  ['guarantor', 'inheritance', 'savings', 'portfolio', 'trust', 'deed']
end