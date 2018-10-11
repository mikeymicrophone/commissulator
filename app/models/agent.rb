require 'google/api_client/client_secrets'

class Agent < ApplicationRecord
  has_many :assists, :dependent => :nullify
  belongs_to :avatar, :optional => true
  has_many :deals
  has_many :commissions
  has_many :registrations
  
  has_many_attached :cookies
  
  enum :status => [:active, :inactive]
  attr_default :status, 'active'
  
  scope :active, lambda { where :status => 'active' }
  scope :alpha, lambda { order :first_name }
  
  def name
    "#{first_name} #{last_name}"
  end
  
  def payable_name
    if payable_first_name.present?
      "#{payable_first_name} #{payable_last_name}"
    else
      name
    end
  end
  
  def distinct_payable_name
    "#{payable_first_name} #{payable_last_name}"
  end
  
  def fub_user
    FubClient::User.find follow_up_boss_id
  end
  
  def Agent.google_auth_client
    client_secrets = Google::APIClient::ClientSecrets.load Rails.root.join('config', 'cookies', 'staging_google_client_id.json')
    auth_client = client_secrets.to_authorization
    auth_client.update!(
      :scope => 'https://www.googleapis.com/auth/calendar.events',
      :redirect_uri => url_helpers.avatar_google_oauth2_omniauth_callback_url
    )
    auth_client
  end
  
  def Agent.google_auth_uri
    google_auth_client.authorization_uri.to_s
  end
  
  def fetch_google_access_tokens auth_client
    auth_client ||= Agent.google_auth_client
    auth_client.code = "4/dQD261Wr3mjxIk_LrXM4V3RO96fyWUJhnqzUIbyAvbzDlPAe7VOI7qtkqT3qdr2LYLycr6C4nYUU0DygR3oLDXM"
    auth_client.fetch_access_token!
  end
  
  def auth_client_with_access
    auth_client = Agent.google_auth_client
    fetch_google_access_tokens auth_client
    auth_client
  end
  
  def secure_microsoft_token
    client = OAuth2::Client.new(
      Rails.application.credentials.microsoft[:"#{Rails.env.production? ? '' : 'staging_'}application_id"],
      Rails.application.credentials.microsoft[:"#{Rails.env.production? ? '' : 'staging_'}password"],
      :site => "https://login.microsoftonline.com",
      :authorize_url => "/common/oauth2/authorize",
      :token_url => "/common/oauth2/token"
    )

    token = client.auth_code.get_token(
      cookies.last.download,
      :redirect_uri => "http://localhost:3000/avatars/auth/microsoft_office365/callback",
      :resource => 'https://outlook.office365.com'
    )
  end
end
