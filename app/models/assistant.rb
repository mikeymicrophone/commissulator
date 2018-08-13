class Assistant < ApplicationRecord
  has_many :participants
  enum :status => [:active, :inactive]
  
  scope :recent, lambda { order 'updated_at desc'}
  
  def name
    "#{first_name} #{last_name}"
  end
end
