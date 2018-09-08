class ReferralSource < ApplicationRecord
  has_many :registrations
  has_many :clients, :through => :registrations
  has_many :landlords, :through => :registrations
  has_many :leases, :through => :registrations
  has_many :industries, :through => :clients
end
