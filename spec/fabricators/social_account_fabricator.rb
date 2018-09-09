Fabricator :social_account do
  moniker { Faker::Internet.username }
  variety { social_networks.sample }
  url { |attrs| Faker::Internet.url(attrs[:variety].downcase + '.com', '/' + attrs[:moniker]) }
  client { find_or_fabricate :client }
  employer { find_or_fabricate :employer if die_roll }
end

Fabricator :work_social_account, :from => :social_account do
  client { nil }
  employer { find_or_fabricate :employer }
end

def social_networks
  ['Facebook', 'Instagram', 'YouTube', 'Twitter', 'Quora', 'Pinterest', 'Tumblr', 'Snapchat', 'LinkedIn']
end
