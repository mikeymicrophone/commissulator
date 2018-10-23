classic = Package.find_or_create_by :name => 'Classic'

lead = Role.find_or_create_by :name => 'lead'
interview = Role.find_or_create_by :name => 'interview'
show = Role.find_or_create_by :name => 'show'
close = Role.find_or_create_by :name => 'close'

Involvement.find_or_create_by :role => lead, :package => classic, :rate => 10.0
Involvement.find_or_create_by :role => interview, :package => classic, :rate => 14.0
Involvement.find_or_create_by :role => show, :package => classic, :rate => 19.5
Involvement.find_or_create_by :role => close, :package => classic, :rate => 16.5

ReferralSource.find_or_create_by :name => 'Apartments.com'
ReferralSource.find_or_create_by :name => 'StreetEasy'
ReferralSource.find_or_create_by :name => 'Other'
