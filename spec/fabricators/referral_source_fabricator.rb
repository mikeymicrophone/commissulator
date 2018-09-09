Fabricator :referral_source do
  name { existing_referral_sources.sample }
  active true
end

def existing_referral_sources
  %W{ Referral Website StreetEasy Naked\ Apartments On-Line\ Ads Print\ Ads Instagram Facebook Twitter YouTube Yelp Trulia Zumper Padlister RentHop NY\ Times Realtor.com Wall\ Street\ Journal Walk-in }
end
