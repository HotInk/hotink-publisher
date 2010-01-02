# Allow the metal piece to run in isolation
require(File.dirname(__FILE__) + "/../../config/environment") unless defined?(Rails)

class Sso < Sinatra::Base
  use Keymaster::Client::Middleware do |sso|
    sso.sso_url = "#{HOTINK_SETTINGS[:site]}/sso"
  end
end
