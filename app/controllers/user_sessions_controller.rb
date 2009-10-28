class UserSessionsController < ApplicationController

  def new
    @account =  Account.find_by_account_resource_id(params[:account_id])
    if params[:request_url]
      redirect_to params[:request_url] 
      return
    elsif params[:account_id]
      redirect_to account_control_panel_path(:account_id => @account.id)
      return
    end
    render :status => 404
  end

  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = "Login successful!"
      redirect_back_or_default account_control_panel_path(:account_id => params[:account_id])
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
