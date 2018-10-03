include CommissionsHelper
class Lease < ApplicationRecord
  belongs_to :landlord, :optional => true
  has_many :tenants
  has_many :clients, :through => :tenants
  has_one :commission
  belongs_to :registration, :optional => true
  validates :street_number, :presence => true
  validates :street_name, :presence => true
  
  def name
    "#{address} with #{landlord&.name}"
  end
  
  def address
    "#{street_number} #{street_name}"
  end
  
  def fub_description client_name
    description = "#{client_name} has a lease at #{address} "
    description += "with #{landlord.name} " if landlord.present?
    description += "of apartment #{apartment_number} "
    description += "costing #{number_to_round_currency commission.leased_monthly_rent} until #{commission.lease_end_date.strftime "%B %d %Y"}." if commission.present?
    description += "ending around #{registration.move_moment}." if registration.present?
    description
  end
  
  def annotate_fub
    clients.each do |client|
      tenant_note = FubClient::Note.new
      tenant_note.subject = "Lease parameters"
      tenant_note.body = fub_description client.name
      tenant_note.personId = client.follow_up_boss_id
      tenant_note.isHtml = true
      begin
        tenant_note.save
      rescue NoMethodError => error
        Rails.logger.debug error.inspect
      end
    end
    landlord_note = FubClient::Note.new
    landlord_note.subject = "Lease parameters"
    landlord_note.body = fub_description clients.map(&:name).to_sentence
    landlord_note.personId = landlord.follow_up_boss_id
    landlord_note.isHtml = true
    begin
      landlord_note.save
    rescue NoMethodError => error
      Rails.logger.debug error.inspect
    end
  end
end
