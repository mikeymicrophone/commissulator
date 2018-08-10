class Assistant < ApplicationRecord
  has_many :participants
  
  def name
    "#{first_name} #{last_name}"
  end
end
