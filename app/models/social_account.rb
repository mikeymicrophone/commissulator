class SocialAccount < ApplicationRecord
  belongs_to :client, :optional => true
  belongs_to :employer, :optional => true
end
