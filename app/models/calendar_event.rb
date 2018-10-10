class CalendarEvent < ApplicationRecord
  belongs_to :agent, :optional => true
  
end
