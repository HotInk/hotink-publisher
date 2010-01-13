# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.5' unless defined? RAILS_GEM_VERSION

# Important instance settings
HOTINK_SETTINGS = { :site => "http://hotink.theorem.ca", :session_key => '_hotink_publisher_session', :session_secret => '22kj78a11a301f15f2b366a2f57abc05c7a3f8bbc0e3bcb437a22527ddbfeeada8586bffa9b5bb1ab0vgt6ea59977c5d9e5f5a234705d4d2f9db28d1cdeb8fd' }

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Specify gems that this application depends on and have them installed with rake gems:install
  # config.gem "bj"
  # config.gem "hpricot", :version => '0.6', :source => "http://code.whytheluckystiff.net"
  # config.gem "sqlite3-ruby", :lib => "sqlite3"
  # config.gem "aws-s3", :lib => "aws/s3"

  config.gem 'oauth'
  config.gem "nokogiri"
  
  
  # SSO gems
  config.gem 'sinatra'
  config.gem 'rack-openid', :lib => 'rack/openid'
  config.gem 'gatekeeper'
  
  config.gem "rdiscount",
             :lib    => "rdiscount",
             :source => "http://gems.github.com"
      
  # config.gem 'mislav-will_paginate',
  #             :source => "http://gems.github.com"             
    
  # Only load the plugins named here, in the order given (default is alphabetical).
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Skip frameworks you're not going to use. To use Rails without a database,
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

  config.action_controller.session = {
    :session_key => HOTINK_SETTINGS[:session_key],
    :secret      => HOTINK_SETTINGS[:session_secret]
  }

  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  # Run "rake -D time" for a list of tasks for finding time zone names.
  config.time_zone = 'UTC'


  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
  # config.i18n.default_locale = :de
end


begin
  require 'rdiscount'
  BlueCloth = RDiscount
rescue LoadError
  require 'bluecloth'
end