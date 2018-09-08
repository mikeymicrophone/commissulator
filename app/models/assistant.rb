class Assistant < ApplicationRecord
  has_many :assists, :dependent => :nullify
  belongs_to :agent, :optional => true
  enum :status => [:active, :inactive]
  attr_default :status, 'active'
  
  scope :active, lambda { where :status => 'active' }
  scope :recent, lambda { order 'updated_at desc'}
  
  def name
    "#{first_name} #{last_name}"
  end
  
  def payable_name
    if payable_first_name.present?
      "#{payable_first_name} #{payable_last_name}"
    else
      name
    end
  end
  
  def distinct_payable_name
    "#{payable_first_name} #{payable_last_name}"
  end
end
