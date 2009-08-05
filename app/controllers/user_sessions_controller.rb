class UserSessionsController < ApplicationController

  before_filter :require_user

  def new
    redirect_to :controller=>"admin/pages", :action=>"dashboard", :account_id => params[:account_id]
  end

  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = "Login successful!"
      redirect_back_or_default :controller=>"admin/pages", :action=>"dashboard", :account_id => params[:account_id]
    else
      render :action => :new
    end
  end

  def destroy
    current_user_session.destroy
    flash[:notice] = "Logout successful!"
    redirect_back_or_default new_user_session_url
  end
  
end  
