class Email < ApplicationRecord
  include Sluggable

  belongs_to :client, :optional => true
  belongs_to :employer, :optional => true
  validates :address, :presence => true
  
  VARIETIES = ['home', 'school', 'work', 'office']

  def to_param
    basic_slug([id, client.first_name, client.last_name])
  end
  
  def name
    address
  end
end
