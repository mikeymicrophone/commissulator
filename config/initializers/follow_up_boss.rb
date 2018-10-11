if Rails.env.staging? || Rails.env.development?
  FubClient::Client.instance.api_key = Rails.application.credentials.follow_up_boss[:staging_api_key]
else
  FubClient::Client.instance.api_key = Rails.application.credentials.follow_up_boss[:api_key]
end


module FubClient
  class Task < Resource
  end
end
