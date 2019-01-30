class Tenant < ApplicationRecord
  include Sluggable

  belongs_to :client
  belongs_to :lease
  validates_associated :lease
  validates_associated :client

  def to_param
    basic_slug client.first_name, client.last_name
  end
end
