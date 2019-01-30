class Niche < ApplicationRecord
  include Sluggable

  belongs_to :employer
  belongs_to :industry
  validates_associated :employer
  validates :employer_id, :uniqueness => {:scope => :industry_id}

  def to_param
    basic_slug employer.name
  end
end
