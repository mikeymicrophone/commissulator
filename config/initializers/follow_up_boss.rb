FubClient::Client.instance.api_key = Rails.application.credentials.follow_up_boss[:api_key]

module FubClient
  class Task < Resource
  end
end

module FubClient
  class Appointment < Resource
  end
end
