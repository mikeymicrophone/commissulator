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
  
  def Agent.google_client_id_filename
    Rails.env.production? ? 'google_client_id.json' : 'staging_google_client_id.json'
  end
  
  def Agent.encrypted_google_client_id_filename
    Rails.env.production? ? 'google_client_id.json.enc' : 'staging_google_client_id.json.enc'
  end
  
  def Agent.encrypt_google_client_id
    @encrypted_file = ActiveSupport::EncryptedFile.new content_path: Rails.root.join('config', 'cookies', encrypted_google_client_id_filename), env_key: 'COOKIE_ENCRYPTION_KEY', key_path: Rails.root, raise_if_missing_key: false
    @encrypted_file.write File.open(Rails.root.join('tmp', google_client_id_filename)).read
  end
  
  def Agent.decrypt_google_client_id
    @encrypted_file = ActiveSupport::EncryptedFile.new content_path: Rails.root.join('config', 'cookies', encrypted_google_client_id_filename), env_key: 'COOKIE_ENCRYPTION_KEY', key_path: Rails.root, raise_if_missing_key: false
    File.open(Rails.root.join('tmp', google_client_id_filename), 'w+') do |file|
      file.write @encrypted_file.read
    end
  end
  
  def Agent.google_auth_client
    decrypt_google_client_id
    client_secrets = Google::APIClient::ClientSecrets.load Rails.root.join('config', 'cookies', google_client_id_filename)
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
    auth_client.code = google_exchangeable_code
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
  
  def google_exchangeable_code
    file = cookies.select { |cookie| cookie.filename.to_s == "google_#{id}_#{name}.yml" }.last
    file&.download
  end
  
  def google_tokens
    file = cookies.select { |cookie| cookie.filename.to_s == 'google_access_tokens.json' }.last
    data = file&.download
    JSON.parse data
  end
end
