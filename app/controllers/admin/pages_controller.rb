class Admin::PagesController < ApplicationController

  layout 'admin'
  
  before_filter :require_user

  def dashboard
    
  end

  def index
    @pages = Page.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @admin_pages }
    end
  end

  def show
    @page = Admin::Page.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @page }
    end
  end

  def new
    @page = Admin::Page.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @page }
    end
  end


  def edit
    @page = Admin::Page.find(params[:id])
  end


  def create
    @page = Admin::Page.new(params[:page])

    respond_to do |format|
      if @page.save
        flash[:notice] = 'Admin::Page was successfully created.'
        format.html { redirect_to(@page) }
        format.xml  { render :xml => @page, :status => :created, :location => @page }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @page.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @page = Admin::Page.find(params[:id])

    respond_to do |format|
      if @page.update_attributes(params[:page])
        flash[:notice] = 'Admin::Page was successfully updated.'
        format.html { redirect_to([@account, @page]) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @page.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @page = Admin::Page.find(params[:id])
    @page.destroy

    respond_to do |format|
      format.html { redirect_to(account_pages_url) }
      format.xml  { head :ok }
    end
  end
end
