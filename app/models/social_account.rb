class SocialAccount < ApplicationRecord
  include Sluggable

  belongs_to :client, :optional => true
  belongs_to :employer, :optional => true

  def to_param
    basic_slug client.first_name, client.last_name, variety
  end
  
  def name
    moniker
  end
end
