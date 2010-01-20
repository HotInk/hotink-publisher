class RedesignsController < ApplicationController

  def create
    @redesign = @account.redesigns.build(params[:redesign])
    @redesign.save
    redirect_to account_control_panel_url(@account)
  end

end
