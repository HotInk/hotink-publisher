class PressRunsController < ApplicationController
  
  def create
    @press_run = @account.press_runs.build(params[:press_run])
    if @press_run.save
      redirect_to account_dashboard_url(@account)
    else
      render :text => "Error updating front page", :status => 500
    end
  end

end
