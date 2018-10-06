include ActionView::Helpers::NumberHelper
include ActionView::Helpers::TextHelper
include CommissionsHelper
class Registration < ApplicationRecord
  belongs_to :referral_source, :optional => true
  belongs_to :agent, :optional => true
  has_many :registrants, :dependent => :destroy
  has_many :clients, :through => :registrants
  has_many :apartments, :dependent => :destroy
  has_many :leases, :dependent => :destroy
  has_many :landlords, :through => :leases
  has_many :employments, :through => :clients
  has_many :employers, :through => :employments
  
  def name
    "Reg #{id} on #{created_at.strftime "%-m/%-d"}"
  end
  
  APARTMENT_SIZES = ['Studio', 'One Bedroom', 'Two Bedroom', 'Three Bedroom', 'Four Bedroom']
  
  def fub_people
    clients.map &:fub_person
  end
  
  def fub_employers
    employers.map &:fub_person
  end
  
  def fub_landlords
    landlords.map &:fub_person
  end
  
  def search_parameters
    "Seeking #{size} for #{minimum_price.present? ? "between #{number_to_round_currency minimum_price} and " : ''}#{number_to_round_currency maximum_price}." if size.present? || minimum_price.present? || maximum_price.present?
  end
  
  def move_moment
    (move_by.present? && move_by_latest.present?) ? "between #{move_by.strftime("%B %-d")} and #{move_by_latest.strftime("%B %-d")}" : "#{move_by&.strftime("%B %-d")}#{move_by_latest&.strftime("%B %-d")}"
  end
  
  def rationale
    "Wants to move #{move_moment}#{reason_for_moving.present? ? " because of #{reason_for_moving}" : ''}." if reason_for_moving.present? || move_by.present? || move_by_latest.present?
  end
  
  def funding_sources
    "Funding sources: #{registrants.map(&:other_fund_sources).select(&:present?).to_sentence}" if registrants.map(&:other_fund_sources).any?(&:present?)
  end
  
  def fub_description
    <<~DESCRIBE
    #{search_parameters}
    #{rationale}
    Looking on behalf of #{pluralize occupants, 'occupant'}#{pets.present? ? ", #{pets}" : ''}.
    #{funding_sources}
    DESCRIBE
  end
  
  def annotate_fub
    fub_people.each do |person|
      note = FubClient::Note.new
      note.subject = 'Registration parameters'
      note.body = fub_description
      note.isHtml = true
      note.personId = person.id
      begin
        note.save
      rescue NoMethodError => error
        Rails.logger.debug error.inspect
      end
    end
  end
  
  def follow_up!
    fub_people.each do |person|
      begin
        person.source = 'in-person registration'
        # person.collaborators = [{:id => 2, :name => 'Uriah Coldtown', :assigned => true}] #agent&.fub_user&.id}]
        event = FubClient::Event.new :type => 'Registration'
        event.person = person
        event.source = 'Commissulator'
        event.save
      rescue NoMethodError => error
        Rails.logger.debug error.inspect
      end
    end
    fub_employers
    fub_landlords
  end
  
  def fully_annotate_fub!
    annotate_fub
    employments.each &:annotate_fub
    leases.each &:annotate_fub
  end
  
  def fub_add_collaborator
    driver = FubCollaborator.new
    driver.load_cookie
    clients.each do |client|
      driver.add_collaborator agent, client
    end
  end
  
  def Registration.rent_budget_prices
    pricing_parameters = HashWithIndifferentAccess.new YAML.load File.open(Rails.root.join('config', 'logistics', 'rent_budget_level_parameters.yml'))
    prices = []
    price_ranges = pricing_parameters[:budgets][:step_groups]
    price_ranges.each do |price_range, parameters|
      parameters.each do |label, value|
        parameters[label] = value.to_d
      end
    end
    
    current_price = pricing_parameters[:budgets][:start_price].to_d
    while current_price <= pricing_parameters[:budgets][:end_price].to_d
      prices << current_price
      stepped = false
      
      price_ranges.each do |label, price_range|
        if !stepped && current_price >= price_range[:start_price] && current_price <= price_range[:end_price]
          current_price += price_range[:step_size]
          stepped = true
        end
      end
    end
    
    prices
  end
end
