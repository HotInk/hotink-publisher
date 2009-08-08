class FrontPagesController < ApplicationController
  
  layout 'admin'

  # GET /front_pages
  # GET /front_pages.xml
  def index
    @front_pages = @account.front_pages.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @front_pages }
    end
  end

  # GET /front_pages/1
  # GET /front_pages/1.xml
  def show
    @front_page = @account.front_pages.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @front_page }
    end
  end

  # GET /front_pages/new
  # GET /front_pages/new.xml
  def new
    @front_page = @account.front_pages.build

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @front_page }
    end
  end

  # GET /front_pages/1/edit
  def edit
    @front_page = @account.front_pages.find(params[:id])
  end

  # POST /front_pages
  # POST /front_pages.xml
  def create
    @front_page = @account.front_pages.build(params[:front_page])

    respond_to do |format|
      if @front_page.save
        flash[:notice] = 'FrontPage was successfully created.'
        format.html { redirect_to([@account, @front_page]) }
        format.xml  { render :xml => @front_page, :status => :created, :location => [@account, @front_page] }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @front_page.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /front_pages/1
  # PUT /front_pages/1.xml
  def update
    @front_page = @account.front_pages.find(params[:id])

    respond_to do |format|
      if @front_page.update_attributes(params[:front_page])
        flash[:notice] = 'FrontPage was successfully updated.'
        format.html { redirect_to([@account, @front_page]) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @front_page.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /front_pages/1
  # DELETE /front_pages/1.xml
  def destroy
    @front_page = @account.front_pages.find(params[:id])
    @front_page.destroy

    respond_to do |format|
      format.html { redirect_to(account_front_pages_url(@account)) }
      format.xml  { head :ok }
    end
  end
end
