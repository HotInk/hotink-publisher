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
      @account.name
    end

end
