class DashboardsController < ApplicationController
  layout 'admin'
  
  
  def show
    @press_run = @account.press_runs.build
  end
end
