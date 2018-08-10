class Participant < ApplicationRecord
  belongs_to :deal
  belongs_to :assistant
  enum :role => [:lead, :interview, :show, :close]
  enum :status => [:preliminary, :active, :removed]
end
