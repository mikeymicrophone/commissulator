class Involvement < ApplicationRecord
  include Sluggable

  belongs_to :package
  belongs_to :role

  def to_param
    basic_slug package.name, role.name
  end
end
