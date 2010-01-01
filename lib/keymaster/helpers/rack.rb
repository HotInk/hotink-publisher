module Keymaster
  module Client
    module Helpers
      module Rack
        def sso_logged_in?
          session[:sso] && sso_user_id
        end

        def sso_login_as(user_id, sreg_params)
          session.delete(:last_oidreq)
          session.delete('OpenID::Consumer::last_requested_endpoint')
          session.delete('OpenID::Consumer::DiscoveredServices::OpenID::Consumer::')

          session[:sso] ||= { }
          session[:sso][:user_id] = user_id
          sreg_params.each { |key, value| session[:sso][key.to_sym] = value.to_s }
        end

        def sso_user_id
          session[:sso][:user_id]
        end

        def sso_user_email
          session[:sso][:email]
        end

        def absolute_url(suffix = nil)
          port_part = case request.scheme
                      when "http"
                        request.port == 80 ? "" : ":#{request.port}"
                      when "https"
                        request.port == 443 ? "" : ":#{request.port}"
                      end
          "#{request.scheme}://#{request.host}#{port_part}#{suffix}"
        end

        def excluded_path?
          options.exclude_paths && options.exclude_paths.include?(request.path_info)
        end
      end
    end
  end
end
