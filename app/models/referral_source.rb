class ReferralSource < ApplicationRecord
  include Sluggable

  has_many :registrations
  has_many :clients, -> { distinct }, :through => :registrations
  has_many :landlords, -> { distinct }, :through => :registrations
  has_many :leases, :through => :registrations
  has_many :industries, -> { distinct }, :through => :clients
  validates :name, :uniqueness => true, :presence => true

  def to_param
    basic_slug name
  end
end
