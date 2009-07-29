# Filters added to this controller apply to all controllers in6 the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  OAUTH_CREDENTIALS = { :token => INSERT_OAUTH_CONSUMER_TOKEN_HERE, :secret => INSERT_OAUTH_CONSUMER_SECRET_HERE, :site => HOTINK_SETTINGS.site }
 
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :passwcord

  # before_filter :set_facebook_session
  # helper_method :facebook_session

  before_filter :find_account
  before_filter :set_liquid_variables
  
  theme :get_theme
  
  private
  
    def find_account
      if params[:account_id]
        @account = Account.find(params[:account_id])
        Time.zone = @account.time_zone
        @account
      else
        false
      end
      
    end

    def set_liquid_variables

      # looks like we can do this properly in the include tag
      # Liquid::Template.file_system.root = "#{RAILS_ROOT}/themes/#{self.current_theme}/views"
      
      @newspaper = Liquid::NewspaperDrop.new(@account)
      @site = Liquid::SiteDrop.new(self)
    end
    
    def get_theme
      # @account.name
    end
    
    # Remote session / User authentication code below
    
    def current_user_session
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = UserSession.find
    end

    def current_user
      return @current_user if defined?(@current_user)
      @current_user = current_user_session && current_user_session.user
    end


    # This function handles authentication for all application users.
    # First, it checks to see if user is already logged in
    # Second, it checks params[:session_action], to see if session negotiation is ongoing.
    # Third, it checks for params[:oauth_token] to see if this is a callback_url response to request_token authorization.
    def require_user

      #First, check to see if user is already logged in
      unless current_user 

        # Second, check to see if session negotiation is ongoing  
        if params[:session_action]
          redirect_to new_user_path and return if params[:session_action]=="new_user"
        end 

        # Third, check to see if this is a logged-in, existing user (w/signed approval form Hot Ink) or a request_token authorization callback response
        if params[:oauth_token]
          if params[:sig]
            # This is where we actually authenticate
            access_token = OauthToken.find_by_token(params[:oauth_token])
            if access_token&&params[:sig]==Digest::SHA1.hexdigest(access_token.token + access_token.secret)
              # Signature matches, it's really Hot Ink and the user checks out. Log 'em in.
              UserSession.create!(access_token.user)
            else
              # Either Hot Ink is confused, or someone's trying to break in
              render :status => 401
              return
            end
          else
            redirect_to new_user_path(:oauth_token => params[:oauth_token])
            return
          end 
        end



        # Last resort, this must be a fresh user request. Forward along to Hot Ink to authenticate.
        redirect_to "#{HOTINK_SETTINGS.site}/remote_session/new?key=#{OAUTH_CREDENTIALS[:token]}"
        return false
      end
    end

    def get_consumer
      require 'oauth/consumer'
      require 'oauth/signature/rsa/sha1'
      consumer = OAuth::Consumer.new(OAUTH_CREDENTIALS[:token], OAUTH_CREDENTIALS[:secret], { :site => OAUTH_CREDENTIALS[:site] })
    end

    def load_access_token
      @access_token = OAuth::AccessToken.new(get_consumer, current_user.oauth_token.token, current_user.oauth_token.secret)
    end

end
