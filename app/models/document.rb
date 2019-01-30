class Document < ApplicationRecord
  include Sluggable

  belongs_to :avatar
  belongs_to :deal, :optional => true
  has_one :commission, :through => :deal
  
  has_one_attached :capture
  
  after_save :remove_symbols, :if => :is_payment?
  
  scope :commission_payments, -> { where :role => ['Proof of Commission Payment', 'Owner Pay Invoice'] }

  def to_param
    basic_slug name, deal.to_param
  end
  
  def remove_symbols
    update_attribute :name, name.gsub('$', '').gsub(',', '') if name =~ /[$,]/
  end
  
  def is_payment?
    self.class.where(:id => id).commission_payments.include? self
  end
end
