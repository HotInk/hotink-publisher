class EntriesController < ApplicationController

  layout 'default'
  
  def show
    
    @blog = Blog.find(params[:blog_id].to_i, :params => {:account_id => params[:account_id].to_i})    
    @entry = Entry.find(params[:id].to_i, :params => {:blog_id => params[:blog_id], :account_id => params[:account_id].to_i})    
    
    render :text => @entry.bodytext    
  end
end