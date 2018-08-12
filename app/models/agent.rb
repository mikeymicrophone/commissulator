class Agent < ApplicationRecord
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :deals
  
  def name
    "#{first_name} #{last_name}"
  end
  
  def reference
    if first_name.present?
      "#{first_name}"
    else
      email
    end
  end
end
