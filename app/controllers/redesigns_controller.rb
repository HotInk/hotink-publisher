class RedesignsController < ApplicationController
  
  
  def create
    @redesign = @account.redesigns.build(params[:redesign])
    if @redesign.save
      redirect_to account_dashboard_url(@account)
    else
      render :text => "Error updating front page", :status => 500
    end
  end
  
end
