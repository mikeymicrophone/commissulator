class Assistant < ApplicationRecord
  has_many :participants
  enum :status => [:active, :inactive]
  
  def name
    "#{first_name} #{last_name}"
  end
end
