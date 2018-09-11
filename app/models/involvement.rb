class Involvement < ApplicationRecord
  belongs_to :package
  belongs_to :role
end
