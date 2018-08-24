class Assistant < ApplicationRecord
  has_many :participants, :dependent => :nullify
  enum :status => [:active, :inactive]
  attr_default :status, 'active'
  
  scope :active, lambda { where :status => 'active' }
  scope :recent, lambda { order 'updated_at desc'}
  
  def name
    "#{first_name} #{last_name}"
  end
end
