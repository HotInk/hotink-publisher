# Filters added to this controller apply to all controllers in6 the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
 
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :passwcord

  # before_filter :set_facebook_session
  # helper_method :facebook_session

  before_filter :find_account
  before_filter :require_user
  before_filter :load_access_token
  
  private
  
    def find_account
      begin
        if params[:account_id]
          @account = Account.find(params[:account_id])
          Time.zone = @account.time_zone
          @account
        elsif controller_name=="accounts" && params[:id]
          @account = Account.find(params[:id])
          Time.zone = @account.time_zone
          @account
        else
          @account = nil
        end
      rescue # Any errors while finding the account mean you're in at the wrong URL.
        zissou
      end
    end
    
    def find_design
      if params[:design_id]
        @design = @account.designs.find(params[:design_id])
      else
        false
      end
    end
    
    def find_template
      if params[:design_id] && current_user
        @current_template = @account.designs.find(params[:design_id]).templates.find_by_role("#{controller_name}/#{action_name}")
      else
        @current_template = @account.current_design.templates.find_by_role("#{controller_name}/#{action_name}")
      end
      raise ActiveRecord::RecordNotFound unless @current_template
      rescue
        zissou
    end
    
    def require_design
      unless @account && @account.current_design
        render :text => "This site is currently offline", :status => 503    
        return
      end
    end
    
    def require_current_front_page
      if @account.current_front_page.blank?
        render :text => "This site is currently offline", :status => 503
        return
      end
    end
        
    def set_liquid_variables      
      @newspaper = Liquid::NewspaperDrop.new(@account)
      @site = Liquid::SiteDrop.new(self)
    end
    
    def get_theme
      @account.name unless @account.nil?
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
      unless (current_user && current_user.account==@account) || ( current_user && current_user.account.id==1 )
        logger.info "Current user: " + current_user.class.name

        # Second, check to see if session negotiation is ongoing  
        if params[:session_action]
          if params[:request_url] # preserve a passed along request url
            redirect_to new_user_path(:request_url => params[:request_url], :account_id => params[:account_id]) and return if params[:session_action]=="new_user"
          else
            redirect_to new_user_path(:account_id => params[:account_id]) and return if params[:session_action]=="new_user"  
          end
        end 

        # Third, check to see if this is a logged-in, existing user (w/signed approval form Hot Ink) or a request_token authorization callback response
        if params[:oauth_token]
          if params[:sig]

            # This is where we actually authenticate
            access_token = OauthToken.find_by_token(params[:oauth_token])
            
            if access_token&&params[:sig]==Digest::SHA1.hexdigest(access_token.token + access_token.secret)

              # Signature matches, it's really Hot Ink and the user checks out. Log 'em in.
              UserSession.create!(access_token.user)

              # If a request url was forwarded along, send them there. 
              # This will preserve any query-string values set by Hot Ink.            
              if params[:request_url]  
                redirect_to(params[:request_url])
                return
              end

            else
              # Either Hot Ink is confused, or someone's trying to break in
              render :text => "Oauth verification not accepted.", :status => 401
              return
            end

          else
            redirect_to new_user_path(:oauth_token => params[:oauth_token], :request_url => params[:request_url], :account_id => params[:account_id])
            return
          end 
        end

        # Last resort, this must be a fresh user request. Forward along to Hot Ink to authenticate.
        redirect_to "#{OAUTH_CREDENTIALS[:site]}/remote_session/new?key=#{OAUTH_CREDENTIALS[:token]}&request_url=#{request.url}&account_id=#{params[:account_id]}"
        return false
      end
    end

    def get_consumer
      require 'oauth/consumer'
      require 'oauth/signature/rsa/sha1'
      consumer = OAuth::Consumer.new(OAUTH_CREDENTIALS[:token], OAUTH_CREDENTIALS[:secret], { :site => OAUTH_CREDENTIALS[:site] })
    end

    def load_access_token
      if current_user && @account
        # Use the current user's access token whenever posssible to keep the best records of who's doing what in the Hot Ink logs
        @account.access_token = OAuth::AccessToken.new(get_consumer, current_user.oauth_token.token, current_user.oauth_token.secret)
        logger.info "Using current user's access token."
      elsif @account && @account.users.first
        logger.info "User token belonging to #{@account.users.first.id.to_s}"
        @account.access_token = OAuth::AccessToken.new(get_consumer, @account.users.first.oauth_token.token, @account.users.first.oauth_token.secret)
        logger.info "Token: #{@account.access_token.token.to_s}"
      else
        logger.info "No access token for this request. No users on account #{@account.id.to_s}"
      end
    end
    
    # This method loads widget data for public templates
    def load_widget_data
     if @current_template && @account
        # Build query of only the necessary ids, from the widgets      
        unless @current_template.required_article_ids.blank?           
          @registers[:widget_data] = @current_template.parsed_widget_data( hash_by_id(Article.find_by_ids(@current_template.required_article_ids.reject{ |i| i.blank? }, :account_id => @account.account_resource_id)) )
        end
     end
    end
    
    # Method to build the necessary context registers for Liquid from controller instance variables.
    def build_registers
      @registers ||= { :account => @account }
      @registers[:design] = @current_template.design if @current_template && @current_template.design
    end
    
    def zissou
      render :file => "zissou.html", :status => 404
      return
    end
    
end
