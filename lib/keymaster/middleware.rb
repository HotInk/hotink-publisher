module Keymaster
  module Client
    class Middleware < DefaultMiddleware
      register ::Keymaster::Client::SSO
    end
  end
end
