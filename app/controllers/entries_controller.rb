class EntriesController < ApplicationController

  layout 'default'
  
  def show
    
    @blog = Blog.find(params[:blog_id].to_i, :params => {:account_id => @account.account_resource_id})    
    @entry = Entry.find(params[:id].to_i, :params => {:blog_id => params[:blog_id], :account_id => @account.account_resource_id})    
      
    render :text => @entry.bodytext    
  end
end