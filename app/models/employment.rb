class Employment < ApplicationRecord
  belongs_to :client
  belongs_to :employer
  validates_associated :employer
end
