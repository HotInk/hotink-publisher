class ControlPanelsController < ApplicationController
  layout 'admin'
  
  def show
    @press_run = @account.press_runs.build
    @redesign = @account.redesigns.build(:design => @account.current_design)
    @draft_front_pages = @account.front_pages.drafts.all(:order => "updated_at DESC", :limit => 15)
  end
  
end
