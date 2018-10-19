class FubAuthenticated
  extend Memoist
  AUTH_COOKIE_CODE = 'rdack2'
  
  attr_accessor :agent
  
  def browser
    b = Watir::Browser.new :chrome, :headless => true
    b.window.resize_to 1600, 1200
    b
  end
  memoize :browser
  
  def login_submit
    browser.goto 'https://login.followupboss.com/login'
    browser.text_field(:id => 'Email').set Rails.application.credentials.follow_up_boss[:login_identity][agent.last_name.to_sym]
    browser.text_field(:id => 'Password').set Rails.application.credentials.follow_up_boss[:login_password][agent.last_name.to_sym]
    browser.form(:id => 'form').submit
    browser.form(:action => '/login/index').wait_while &:exists?
  end
  
  def store_cookie
    browser.goto domain
    browser.cookies.to_a.each do |cookie_hash|
      browser.cookies.delete(cookie_hash[:name]) unless cookie_hash[:name] == AUTH_COOKIE_CODE
    end
    browser.cookies.save cookie_filename
    
    agent.cookies.attach io: File.open(cookie_filename), filename: "fub_#{agent.id}_#{agent.name.underscore.gsub(/\s/, '_')}.yml"
  end
  
  def load_cookie
    File.open cookie_filename, 'w+' do |file|
      file.write agent.cookies.select { |cookie| cookie.filename.to_s == "fub_#{agent.id}_#{agent.name.underscore.gsub(/\s/, '_')}.yml" }.last.download
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
    "#{Rails.application.credentials.follow_up_boss[:subdomain]}.followupboss.com/2/dashboard"
  end
end
