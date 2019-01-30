class Registrant < ApplicationRecord
  include Sluggable

  belongs_to :client
  belongs_to :registration

  def to_param
    basic_slug client.first_name, client.last_name
  end
  
  def name
    "#{client.name} in #{registration.name}"
  end
end
