class Niche < ApplicationRecord
  belongs_to :employer
  belongs_to :industry
  validates_associated :employer
  validates :employer_id, :uniqueness => {:scope => :industry_id}
end
