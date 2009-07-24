class BlogsController < ApplicationController

  layout 'default'

  
  def index
    @blogs = @account.blogs

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @article }
    end
  end

  def show
    @blog = Blog.find(params[:id], :params => {:account_id => params[:account_id]})
    @entries = @blog.entries      
      
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @blog }
    end
  end

end