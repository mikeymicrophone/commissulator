class Avatar < ApplicationRecord
  include Sluggable

  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable#, :omniauthable, :omniauth_providers => [:contactually, :google_oauth2, :microsoft_office365]

  has_one :agent
  has_many :deals, :through => :agent
  has_many :assists, :through => :deals
  has_many :agents, -> { distinct }, :through => :assists
  has_many :commissions, :through => :agent
  
  after_create :introduce_to_admin
  
  scope :alpha, lambda { order :first_name }
  scope :admin, lambda { where :admin => true }
  
  def self.from_omniauth auth
    avatar = Avatar.where(:google_email => auth.info.email).take
    
    avatar ||= Avatar.where(:email => auth.info.email).take
    if avatar
      avatar.provider = auth.provider
      avatar.uid = auth.uid
      avatar.save
      avatar
    else
      where(provider: auth.provider, uid: auth.uid).first_or_create do |avatar|
        avatar.email = auth.info.email
        avatar.password = Devise.friendly_token[0,20]
        avatar.skip_confirmation!
      end
    end
  end

  def to_param
    basic_slug first_name, last_name
  end
  
  def name
    "#{first_name} #{last_name}"
  end
  
  def reference
    if first_name.present?
      "#{first_name}"
    else
      email
    end
  end
  
  def active_for_authentication?
    super && activated?
  end
  
  def introduce_to_admin
    PersonnelMailer.with(:avatar => self).activation_request.deliver
  end
end
