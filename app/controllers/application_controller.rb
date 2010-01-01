# Filters added to this controller apply to all controllers in6 the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
 
  include ApplicationHelper
  #protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :passwcord

  # before_filter :set_facebook_session
  # helper_method :facebook_session

  before_filter :find_account
  before_filter :require_user
  
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
        @account.url = "/accounts/#{@account.account_resource_id}/designs/#{params[:design_id]}"
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
    
    def require_user
     #logger.info session.inspect
     if session[:sso] && session[:sso][:user_id]
       if (session[:sso][:is_admin?]=='true')||(session[:sso]["account_#{@account.account_resource_id.to_s}_manager".to_sym]=='true')
         true
       else
         render :text => "unauthorized!", :status => 401
         return
       end
     else
       redirect_to "/sso/login?return_to=#{request.request_uri}"
       false
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
