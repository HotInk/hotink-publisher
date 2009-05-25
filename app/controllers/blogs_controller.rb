class BlogsController < ApplicationController

  theme 'varsity'  
  layout 'default'

  
  def index
    @blogs = Blog.find(:all, :params => {:account_id => @account.id})

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @article }
    end
  end

  def show
    @blog = Blog.find(params[:id], :params => {:account_id => @account.id})
      
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @blog }
    end
  end

end
