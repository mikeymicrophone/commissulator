class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  
  def foreign_key_name
    self.class.name.underscore + '_id'
  end
end
