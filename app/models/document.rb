class Document < ApplicationRecord
  belongs_to :agent
  belongs_to :deal, :optional => true
  
  has_one_attached :capture
end
