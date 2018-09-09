class Document < ApplicationRecord
  belongs_to :avatar
  belongs_to :deal, :optional => true
  has_one :commission, :through => :deal
  
  has_one_attached :capture
  
  scope :commission_payments, -> { where :role => ['Proof of Commission Payment', 'Owner Pay Invoice'] }
end
