module Sluggable
  extend ActiveSupport::Concern

  def basic_slug(*parts)
    [id, *parts].map do |part|
      part.to_s.downcase.gsub(/\W+/, '-')
    end.join('-')
  end
end
