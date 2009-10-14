class DesignImportsController < ApplicationController
  
  def new
    @designs = Design.find_all_by_account_id_and_public(1, true, :order => "created_at DESC")
  end
  
  def create
    @design = Design.new
    @design_to_import = Design.find_by_id_and_account_id(params[:design_id], 1)
    @design.attributes = @design_to_import.attributes
    @design.parent = @design_to_import
    @design.public = false
    @design.account = @account
    @design.save  
  end
  
  def show
  end
  
end
