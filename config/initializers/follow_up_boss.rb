if Rails.application.credentials.follow_up_boss.present?
  FubClient::Client.instance.api_key = Rails.application.credentials.follow_up_boss[:api_key]
end

module FubClient
  class Task < Resource
  end
end

module FubClient
  class Appointment < Resource
  end
end
