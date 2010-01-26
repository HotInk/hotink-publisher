class DesignsController < ApplicationController
  
  layout 'admin'
  
  # GET /designs
  def index
    @designs = @account.designs.all

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /designs/1
  def show
    @design = @account.designs.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @design }
    end
  end

  # GET /designs/new
  # GET /designs/new.xml
  def new
    @design = @account.designs.build

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /designs/1/edit
  def edit
    @design = @account.designs.find(params[:id])
  end

  # POST /designs
  # POST /designs.xml
  def create
    @design = @account.designs.build(params[:design])

    respond_to do |format|
      if @design.save
        flash[:notice] = 'Design was successfully created.'
        format.html { redirect_to([@account, @design]) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /designs/1
  # PUT /designs/1.xml
  def update
    @design = @account.designs.find(params[:id])

    respond_to do |format|
      if @design.update_attributes(params[:design])
        format.html { redirect_to([@account, @design]) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /designs/1
  # DELETE /designs/1.xml
  def destroy
    @design = @account.designs.find(params[:id])
    @design.update_attribute(:active, false)

    respond_to do |format|
      format.html { redirect_to(account_designs_url(@account)) }
    end
  end
  
end
