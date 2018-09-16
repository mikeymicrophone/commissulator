class DefaultPackage < ActiveRecord::Migration[5.2]
  def change
    citipads_classic = Package.create :name => 'CitiPads Classic', :active => true
    
    lead = Role.find_or_create_by :name => 'lead'
    interview = Role.find_or_create_by :name => 'interview'
    show = Role.find_or_create_by :name => 'show'
    close = Role.find_or_create_by :name => 'close'
    
    lead_involvement = Involvement.create :package => citipads_classic, :role => lead, :rate => 10
    interview_involvement = Involvement.create :package => citipads_classic, :role => interview, :rate => 12.5
    show_involvement = Involvement.create :package => citipads_classic, :role => show, :rate => 15
    close_involvement = Involvement.create :package => citipads_classic, :role => close, :rate => 12.5
    
    Deal.update_all :package_id => citipads_classic.id
  end
end
