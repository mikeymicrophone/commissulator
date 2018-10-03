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
  
  PRICES = (2..30).to_a.map { |num| num * 500 }.append(1250, 1750, 2250).sort
  APARTMENT_SIZES = ['Alcove Studio', 'Junior-1', 'Studio', 'One Bedroom', 'Junior-4', 'Convertible-2', 'Two Bedroom', 'Convertible-3', 'Classic-6', 'Three Bedroom', 'Classic-7', 'Convertible-4', 'Four Bedroom', 'Five Bedroom+']
  
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
end
