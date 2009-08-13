class DesignsController < ApplicationController
  
  layout 'admin'
  
  # GET /designs
  # GET /designs.xml
  def index
    @designs = @account.designs.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @designs }
    end
  end

  # GET /designs/1
  # GET /designs/1.xml
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
      format.xml  { render :xml => @design }
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
        format.xml  { render :xml => @design, :status => :created, :location => [@account, @design] }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @design.errors, :status => :unprocessable_entity }
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
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @design.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /designs/1
  # DELETE /designs/1.xml
  def destroy
    @design = @account.designs.find(params[:id])
    @design.destroy

    respond_to do |format|
      format.html { redirect_to(account_designs_url(@account)) }
      format.xml  { head :ok }
    end
  end
end
