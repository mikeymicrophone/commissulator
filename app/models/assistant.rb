class Assistant < ApplicationRecord
  has_many :participants, :dependent => :destroy
  enum :status => [:active, :inactive]
  
  scope :active, lambda { where :status => 'active' }
  scope :recent, lambda { order 'updated_at desc'}
  
  def name
    "#{first_name} #{last_name}"
  end
end
