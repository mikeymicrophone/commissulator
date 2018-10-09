class FubAuthenticated
  extend Memoist
  AUTH_COOKIE_CODE = 'rdack2'
  
  attr_accessor :agent
  
  def browser
    Watir::Browser.new :chrome#, :headless => true
  end
  memoize :browser
  
  def login_submit
    browser.goto 'https://login.followupboss.com/login'
    if Rails.env.production?
      browser.text_field(:id => 'Email').set Rails.application.credentials.follow_up_boss[:login_identity]
      browser.text_field(:id => 'Password').set Rails.application.credentials.follow_up_boss[:login_password]
    else
      browser.text_field(:id => 'Email').set Rails.application.credentials.follow_up_boss[:staging_login_identity]
      browser.text_field(:id => 'Password').set Rails.application.credentials.follow_up_boss[:staging_login_password]
    end
    browser.form(:id => 'form').submit
  end
  
  def store_cookie
    sleep 2
    
    browser.goto domain
    browser.cookies.to_a.each do |cookie_hash|
      browser.cookies.delete(cookie_hash[:name]) unless cookie_hash[:name] == AUTH_COOKIE_CODE
    end
    browser.cookies.save cookie_filename
    
    agent.cookies.attach io: File.open(cookie_filename), filename: "fub_#{agent.id}_#{agent.name.underscore.gsub(/\s/, '_')}.yml"
  end
  
  def load_cookie
    File.open cookie_filename, 'w+' do |file|
      file.write agent.cookies.last.download
    end
    browser.goto domain
    browser.cookies.load cookie_filename
  end
  
  def cookie_filename
    file = if Rails.env.production?
      'follow_up_boss_cookie_admin_commissulator.yml'
    else
      'follow_up_boss_cookie_admin_staging.yml'
    end
    Rails.root.join 'tmp', file
  end
  
  def domain
    if Rails.env.production?
      "#{Rails.application.credentials.follow_up_boss[:subdomain]}.followupboss.com/2/dashboard"
    else
      "#{Rails.application.credentials.follow_up_boss[:staging_subdomain]}.followupboss.com/2/dashboard"
    end
  end
end
