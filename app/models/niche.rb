class Niche < ApplicationRecord
  belongs_to :employer
  belongs_to :industry
end
