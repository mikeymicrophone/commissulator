class Avatar < ApplicationRecord
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:contactually]

  has_one :agent
  has_many :deals, :through => :agent
  has_many :assists, :through => :deals
  has_many :agents, -> { distinct }, :through => :assists
  has_many :commissions, :through => :agent
  
  scope :alpha, lambda { order :first_name }
  
  def self.from_omniauth auth
    avatar = Avatar.where(:email => auth.info.email).take
    if avatar
      avatar.provider = auth.provider
      avatar.uid = auth.uid
      avatar.save
    else
      where(provider: auth.provider, uid: auth.uid).first_or_create do |avatar|
        avatar.email = auth.info.email
        avatar.password = Devise.friendly_token[0,20]
        avatar.skip_confirmation!
      end
    end
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
end
