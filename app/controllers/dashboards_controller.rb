class DashboardsController < ApplicationController
  layout 'admin'
  
  
  def show
    @redesign = @account.redesigns.build
    @press_run = @account.press_runs.build
  end
end
