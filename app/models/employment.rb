class Employment < ApplicationRecord
  belongs_to :client
  belongs_to :employer
end
