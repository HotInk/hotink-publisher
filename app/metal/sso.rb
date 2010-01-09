# Allow the metal piece to run in isolation
require(File.dirname(__FILE__) + "/../../config/environment") unless defined?(Rails)
require 'sinatra/base'
require 'logger'

class Sso < Sinatra::Base
  use Keymaster::Client::Middleware do |sso|
    sso.sso_url = "#{HOTINK_SETTINGS[:site]}/sso"
  end
  
  # Log out from alternate account domain
  get "/accounts/:id/logout" do
    session.clear
    redirect "/sso/logout"
  end
end
