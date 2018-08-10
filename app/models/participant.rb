class Participant < ApplicationRecord
  belongs_to :deal
  belongs_to :assistant
  enum :role => [:lead, :interview, :show, :close]
  enum :status => [:preliminary, :active, :removed]
  
  scope :leading, lambda { where :role => :lead }
  scope :interviewing, lambda { where :role => :interview }
  scope :showing, lambda { where :role => :show }
  scope :closing, lambda { where :role => close }
  
  def name
    "#{role} by #{assistant.first_name}"
  end
end
